import 'package:vfxmoney/core/params/auth_params/auth_params.dart';
import 'package:vfxmoney/features/auth/data/auth_model/auth_user_model.dart';

abstract class AuthRemoteDataSource {
  /// Sends login request. Returns AuthUserModel on success.
  Future<AuthUserModel> login(LoginParams params);
  Future<String> register(RegisterParams params);
  Future<AuthUserModel> verifyEmailOtp(VerifyEmailOtpParams params);
}
