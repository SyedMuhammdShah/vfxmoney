

import 'package:fpdart/fpdart.dart';
import 'package:vfxmoney/core/errors/failure.dart';
import 'package:vfxmoney/features/auth/domain/auth_repositories/auth_repository.dart';
import 'package:vfxmoney/core/usecase/usecase.dart';


class SendPhoneOtpUseCase implements UseCase<void, String> {
  final AuthRepository repository;

  SendPhoneOtpUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String token) async {
    return await repository.sendPhoneOtp(token);
  }
}