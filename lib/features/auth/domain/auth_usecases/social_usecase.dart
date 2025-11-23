import 'package:fpdart/fpdart.dart';
import 'package:vfxmoney/core/errors/failure.dart';
import 'package:vfxmoney/core/params/auth_params/auth_params.dart';
import 'package:vfxmoney/features/auth/domain/auth_entities/auth_user_entity.dart';
import 'package:vfxmoney/features/auth/domain/auth_repositories/social_repositories.dart';

class SocialSignInUseCase {
  final SocialLoginRepository repository;

  SocialSignInUseCase(this.repository);

  Future<Either<Failure, AuthUserEntity>> call(SocialSignInParam params) async {
    return await repository.socialLogin(params: params);
  }
}

class SocialRegisterUseCase {
  final SocialRegisterRepository repository;

  SocialRegisterUseCase(this.repository);

  Future<Either<Failure, AuthUserEntity>> call(
    SocialRegisterParam params,
  ) async {
    return await repository.socialRegister(params: params);
  }
}

class SocialOTPUseCase {
  final SocialOTPRepository repository;

  SocialOTPUseCase(this.repository);

  Future<Either<Failure, AuthUserEntity>> call(SocialOTPParam params) async {
    return await repository.socialOTP(params: params);
  }
}

class SendSocialOTPUseCase {
  final SendSocialOTPRepository repository;

  SendSocialOTPUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.sendSocialOTP();
  }
}

class UpdateFcmUseCase {
  final UpdateFcmRepository updateFcmRepository;

  UpdateFcmUseCase(this.updateFcmRepository);

  Future<Either<Failure, String>> call(UpdateFcmParams params) async {
    return await updateFcmRepository.updateFcm(params: params);
  }
}

class LogoutUseCase {
  final LogoutRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, String>> call() async {
    return await repository.logout();
  }
}

class DeleteAccountUseCase {
  final DeleteAccountRepository repository;

  DeleteAccountUseCase(this.repository);

  Future<Either<Failure, String>> call() async {
    return await repository.deleteAccount();
  }
}
