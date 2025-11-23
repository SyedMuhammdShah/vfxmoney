import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vfxmoney/core/errors/failure.dart';
import 'package:vfxmoney/features/auth/domain/auth_entities/auth_user_entity.dart';
import 'package:vfxmoney/features/auth/domain/auth_repositories/auth_repository.dart';
import 'package:vfxmoney/core/usecase/usecase.dart';


class VerifyPhoneOtpParams extends Equatable {
  final String otp;
  final String token;

  const VerifyPhoneOtpParams({required this.otp, required this.token});

  @override
  List<Object?> get props => [otp, token];
}

class VerifyPhoneOtpUseCase
    implements UseCase<AuthUserEntity, VerifyPhoneOtpParams> {
  final AuthRepository repository;

  VerifyPhoneOtpUseCase(this.repository);

  @override
  Future<Either<Failure, AuthUserEntity>> call(
      VerifyPhoneOtpParams params) async {
    return await repository.verifyPhoneOtp(params.otp, params.token);
  }
}