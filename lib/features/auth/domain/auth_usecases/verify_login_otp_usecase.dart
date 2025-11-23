import 'package:fpdart/fpdart.dart';
import 'package:vfxmoney/core/errors/failure.dart';
import 'package:vfxmoney/core/params/auth_params/verify_login_params.dart';
import 'package:vfxmoney/core/usecase/usecase.dart';
import 'package:vfxmoney/features/auth/domain/auth_entities/auth_user_entity.dart';
import 'package:vfxmoney/features/auth/domain/auth_repositories/auth_repository.dart';

// class VerifyLoginOtpParams {
//   final String otp;
//   final String email;

//   VerifyLoginOtpParams({required this.otp, required this.email});
// }

class VerifyLoginOtpUseCase
    implements UseCase<AuthUserEntity, VerifyLoginOtpParams> {
  final AuthRepository repository;

  VerifyLoginOtpUseCase({required this.repository});

  @override
  Future<Either<Failure, AuthUserEntity>> call(VerifyLoginOtpParams params) {
    return repository.verifyLoginOtp(params);
  }
}
