import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vfxmoney/core/errors/failure.dart';
import 'package:vfxmoney/features/auth/domain/auth_entities/auth_user_entity.dart';
import 'package:vfxmoney/features/auth/domain/auth_repositories/auth_repository.dart';
import 'package:vfxmoney/core/usecase/usecase.dart';


class VerifyEmailOtpParams extends Equatable {
  final String otp;
  final String token;

  const VerifyEmailOtpParams({required this.otp, required this.token});

  @override
  List<Object?> get props => [otp, token];
}

class VerifyEmailOtpUseCase
    implements UseCase<AuthUserEntity, VerifyEmailOtpParams> {
  final AuthRepository repository;

  VerifyEmailOtpUseCase(this.repository);

  @override
  Future<Either<Failure, AuthUserEntity>> call(
      VerifyEmailOtpParams params) async {
    return await repository.verifyEmailOtp(params.otp, params.token);
  }
}