// lib/features/auth/data/datasources/auth_remote_data_source.dart
import 'package:vfxmoney/core/constants/api_endpoints.dart';
import 'package:vfxmoney/core/errors/exceptions.dart';
import 'package:vfxmoney/core/params/auth_params/auth_params.dart';
import 'package:vfxmoney/core/params/auth_params/login_params.dart';
import 'package:vfxmoney/core/params/auth_params/verify_login_params.dart';
import 'package:vfxmoney/core/services/api_service.dart';
import 'package:vfxmoney/core/services/service_locator.dart';
import 'package:vfxmoney/core/services/storage_service.dart';
import 'package:vfxmoney/features/auth/data/auth_model/auth_user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthUserModel> signUp(RegisterProfileParams params);
  Future<void> sendEmailOtp(String token);
  Future<void> sendPhoneOtp(String token);
  Future<void> login(LoginParams params);
  Future<AuthUserModel> verifyLoginOtp(VerifyLoginOtpParams params);
  Future<AuthUserModel> verifyEmailOtp(String otp, String token);
  Future<AuthUserModel> verifyPhoneOtp(String otp, String token);
  Future<AuthUserModel> updateProfile(UpdateProfileParams params);
  Future<void> sendDeleteOtp(String token);
  Future<String> changePhoneNumber(String phone);
  Future<void> deleteAccount({required String otp, required String reason});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;
  final StorageService storageService = locator<StorageService>();
  AuthRemoteDataSourceImpl({required this.apiService});

  @override
  Future<AuthUserModel> signUp(RegisterProfileParams params) async {
    final response = await apiService.post(
      ApiEndpoints.signUpEndpoint,
      payload: params.toFormData(),
      isAuthorize: false,
    );

    if (response.data['success'] == true) {
      return AuthUserModel.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? 'Signup failed');
    }
  }

  @override
  Future<void> login(LoginParams params) async {
    final response = await apiService.post(
      ApiEndpoints.loginEndpoint,
      payload: params.toJson(),
      isAuthorize: false,
    );

    if (response.data['success'] != true) {
      throw Exception(response.data['message'] ?? 'Failed to send login OTP');
    }
  }

  @override
  Future<AuthUserModel> verifyLoginOtp(VerifyLoginOtpParams params) async {
    final response = await apiService.post(
      ApiEndpoints.verifyLoginOtp,
      payload: params.toJson(),
      isAuthorize: false,
    );

    if (response.data['success'] == true) {
      final data = response.data['data'];
      return AuthUserModel.fromJson(data);
    } else {
      throw Exception(response.data['message'] ?? 'Login verification failed');
    }
  }

  @override
  Future<void> sendEmailOtp(String token) async {
    final response = await apiService.post(
      ApiEndpoints.sendEmailVerificationOTPForSignup,
      isAuthorize: true,
      token: token,
    );
    if (response.data['success'] != true) {
      throw Exception(response.data['message'] ?? 'Failed to send email OTP');
    }
  }

  @override
  Future<void> sendPhoneOtp(String token) async {
    final response = await apiService.post(
      ApiEndpoints.sendPhoneVerificationOTPForSignup,
      isAuthorize: true,
      token: token,
    );

    if (response.data['success'] != true) {
      throw Exception(response.data['message'] ?? 'Failed to send phone OTP');
    }
  }

  @override
  Future<AuthUserModel> verifyEmailOtp(String otp, String token) async {
    final response = await apiService.post(
      ApiEndpoints.verifyEmailOTPForSignup,
      payload: {'otp': otp},
      isAuthorize: true,

      // token: token,
    );

    if (response.data['success'] == true) {
      return AuthUserModel.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? 'Email verification failed');
    }
  }

  @override
  Future<AuthUserModel> verifyPhoneOtp(String otp, String token) async {
    final response = await apiService.post(
      ApiEndpoints.verifyPhoneOTPForSignup,
      payload: {'otp': otp},
      isAuthorize: true,
      token: token,
    );

    if (response.data['success'] == true) {
      return AuthUserModel.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? 'Phone verification failed');
    }
  }

  @override
  Future<AuthUserModel> updateProfile(UpdateProfileParams params) async {
    final response = await apiService.put(
      ApiEndpoints.updateProfileEndpoint,
      data: params.toFormData(),
      isAuthorize: true,
    );

    if (response.data['success'] == true) {
      final serverData = response.data['data'];
      await storageService.setUser(serverData);
      return AuthUserModel.fromJson(serverData);
    } else {
      throw Exception(response.data['message'] ?? 'Profile update failed');
    }
  }

  @override
  Future<void> sendDeleteOtp(String token) async {
    final response = await apiService.post(
      ApiEndpoints.sendDeleteAccountOtp, // '/auth/emailVerificationOTP'
      isAuthorize: true,
      token: token,
    );

    if (response.data['success'] != true) {
      throw ServerException(response.data['message'] ?? 'Failed to send OTP');
    }
  }

  @override
  Future<void> deleteAccount({
    required String otp,
    required String reason,
  }) async {
    final response = await apiService.post(
      ApiEndpoints.verifyDeleteAccountOtp,
      payload: {"otp": otp, "reason": reason},
      isAuthorize: true,
    );

    if (response.data['success'] != true) {
      storageService.clear();
      throw ServerException(
        response.data['message'] ?? 'Failed to delete account',
      );
    }
  }

  @override
  Future<String> changePhoneNumber(String phone) async {
    // Ensure the number starts with +1 and doesn’t duplicate it
    final normalizedPhone = phone.startsWith('+1')
        ? phone
        : '+1${phone.replaceAll(RegExp(r'[^0-9]'), '')}';

    final response = await apiService.post(
      ApiEndpoints.changePhoneNumberEndpoint,
      payload: {"phone": normalizedPhone},
      isAuthorize: true,
    );

    if (response.data['success'] != true) {
      throw ServerException(
        response.data['message'] ?? 'Failed to change number',
      );
    }

    final result = response.data['data'];

    // ✅ Handle Map or String responses consistently
    if (result is Map<String, dynamic>) {
      await storageService.setUser(result);
      return result['phone']?.toString() ?? '';
    } else if (result is String) {
      // Sometimes API may just return updated phone as a string
      await storageService.setUser({'phone': result});
      return result;
    } else {
      return response.data['message']?.toString() ?? '';
    }
  }
}
