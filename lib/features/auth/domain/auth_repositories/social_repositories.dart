import 'package:fpdart/fpdart.dart';
import 'package:vfxmoney/core/errors/failure.dart';
import 'package:vfxmoney/core/params/auth_params/auth_params.dart';
import 'package:vfxmoney/features/auth/domain/auth_entities/auth_user_entity.dart';

abstract class UpdateFcmRepository {
  Future<Either<Failure, String>> updateFcm({required UpdateFcmParams params});
}

abstract class SocialLoginRepository {
  Future<Either<Failure, AuthUserEntity>> socialLogin({
    required SocialSignInParam params,
  });
}

abstract class SocialRegisterRepository {
  Future<Either<Failure, AuthUserEntity>> socialRegister({
    required SocialRegisterParam params,
  });
}

abstract class SocialOTPRepository {
  Future<Either<Failure, AuthUserEntity>> socialOTP({
    required SocialOTPParam params,
  });
}

abstract class SendSocialOTPRepository {
  Future<Either<Failure, void>> sendSocialOTP();
}

abstract class LogoutRepository {
  Future<Either<Failure, String>> logout();
}

abstract class DeleteAccountRepository {
  Future<Either<Failure, String>> deleteAccount();
}
