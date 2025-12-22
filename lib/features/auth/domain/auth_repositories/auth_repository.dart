import 'package:vfxmoney/core/params/auth_params/auth_params.dart';
import 'package:vfxmoney/features/auth/domain/auth_entities/auth_user_entity.dart';

abstract class AuthRepository {
  /// Triggers login (server may send OTP or return user + token). Returns UserEntity on success.
  Future<UserEntity> login(LoginParams params);
  Future<String> register(RegisterParams params);

  Future<UserEntity> verifyEmailOtp(VerifyEmailOtpParams params, String token);
}
