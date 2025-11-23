import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vfxmoney/core/params/auth_params/auth_params.dart';
import 'package:vfxmoney/core/services/storage_service.dart';
import 'package:vfxmoney/features/auth/data/auth_model/auth_user_model.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/service_locator.dart';

abstract class SocialDatasource {
  Future<Either<Failure, AuthUserModel>> socialSignIn(SocialSignInParam params);
  Future<Either<Failure, AuthUserModel>> socialRegister(
    SocialRegisterParam params,
  );
  Future<Either<Failure, AuthUserModel>> socialOTP(SocialOTPParam params);
  Future<Either<Failure, void>> sendSocialOTP();
  Future<Either<Failure, String>> updateFcmToken({
    required UpdateFcmParams params,
  });
  Future<Either<Failure, String>> logout();
  Future<Either<Failure, String>> deleteAccount();
}

class SocialDatasourceImpl implements SocialDatasource {
  final ApiService apiService = locator<ApiService>();
  final StorageService storageService = locator<StorageService>();

  @override
  Future<Either<Failure, AuthUserModel>> socialSignIn(
    SocialSignInParam params,
  ) async {
    try {
      Response res = await apiService.post(
        ApiEndpoints.socialLogin,
        payload: params.toJson(),
      );
      AuthUserModel data = AuthUserModel.fromJson(res.data['data']);
      storageService.setUser(data.toJson());
      storageService.setToken(res.data['data']['token'] ?? "");
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message ?? "Error!"));
    }
  }

  @override
  Future<Either<Failure, AuthUserModel>> socialRegister(
    SocialRegisterParam params,
  ) async {
    try {
      Response res = await apiService.post(
        ApiEndpoints.socialRegister,
        payload: params.toFormData(),
        isAuthorize: true,
      );
      AuthUserModel data = AuthUserModel.fromJson(res.data['data']);
      storageService.setUser(data.toJson());
      storageService.setToken(res.data['data']['token'] ?? "");
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message ?? "Error!"));
    }
  }

  @override
  Future<Either<Failure, AuthUserModel>> socialOTP(
    SocialOTPParam params,
  ) async {
    try {
      Response res = await apiService.post(
        ApiEndpoints.verifyPhoneOTPForSignup,
        payload: params.toJson(),
        isAuthorize: true,
      );
      AuthUserModel data = AuthUserModel.fromJson(res.data['data']);
      storageService.setUser(data.toJson());
      storageService.setToken(res.data['data']['token'] ?? "");
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message ?? "Error!"));
    }
  }

  @override
  Future<Either<Failure, void>> sendSocialOTP() async {
    try {
      final response = await apiService.post(
        ApiEndpoints.sendPhoneVerificationOTPForSignup,
        isAuthorize: true,
      );
      final success =
          response.statusCode == 200 || (response.data['status'] == true);
      if (!success) {
        final message = response.data['message'] ?? 'Failed to send OTP';
        return Left(ServerFailure(message));
      }
      return const Right(null);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message ?? "Server error occurred"));
    }
  }

  @override
  Future<Either<Failure, String>> updateFcmToken({
    required UpdateFcmParams params,
  }) async {
    try {
      final response = await apiService.post(
        ApiEndpoints.updateFCM,
        payload: params.toJson(),
        isAuthorize: true,
      );
      final message = response.data['message'] ?? "FCM token updated";
      log("✅ FCM token update success: $message");
      return Right(message);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message ?? "Error!"));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> logout() async {
    try {
      Response res = await apiService.post(
        ApiEndpoints.logout,
        isAuthorize: true,
      );
      final message = res.data['message'];
      storageService.clear();
      await resetLocator();
      return Right(message);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message ?? "Error!"));
    }
  }

  @override
  Future<Either<Failure, String>> deleteAccount() async {
    try {
      Response res = await apiService.post(
        ApiEndpoints.delete,
        isAuthorize: true,
      );
      final message = res.data['message'];
      storageService.clear();
      await resetLocator();
      // locator<SocketService>().disconnect();
      return Right(message);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message ?? "Error!"));
    }
  }
}
