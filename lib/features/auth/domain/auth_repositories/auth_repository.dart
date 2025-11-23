import 'package:fpdart/fpdart.dart';
import 'package:vfxmoney/core/errors/failure.dart';
import 'package:vfxmoney/core/params/auth_params/auth_params.dart';
import 'package:vfxmoney/core/params/auth_params/login_params.dart';
import 'package:vfxmoney/core/params/auth_params/verify_login_params.dart';
import 'package:vfxmoney/features/auth/domain/auth_entities/auth_user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthUserEntity>> signUp(RegisterProfileParams params);
  Future<Either<Failure, void>> login(LoginParams params);
  Future<Either<Failure, AuthUserEntity>> verifyLoginOtp(
    VerifyLoginOtpParams params,
  );
  Future<Either<Failure, void>> sendEmailOtp(String token);
  Future<Either<Failure, void>> sendPhoneOtp(String token);
  Future<Either<Failure, void>> sendDeleteOtp(String token);
  Future<Either<Failure, AuthUserEntity>> verifyEmailOtp(
    String otp,
    String token,
  );
  Future<Either<Failure, AuthUserEntity>> verifyPhoneOtp(
    String otp,
    String token,
  );
  Future<Either<Failure, AuthUserEntity>> updateProfile(
    UpdateProfileParams params,
  );

  Future<Either<Failure, void>> deleteAccount({
    required String otp,
    required String reason,
  });


  Future<Either<Failure, void>> changePhoneNumber(String phone);

}
