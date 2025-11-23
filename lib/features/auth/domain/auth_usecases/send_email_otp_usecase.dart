

import 'package:fpdart/fpdart.dart';
import 'package:vfxmoney/core/errors/failure.dart';
import 'package:vfxmoney/core/usecase/usecase.dart';
import 'package:vfxmoney/features/auth/domain/auth_repositories/auth_repository.dart';

class SendEmailOtpUseCase implements UseCase<void, String> {
  final AuthRepository repository;

  SendEmailOtpUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String token) async {
    return await repository.sendEmailOtp(token);
  }
}