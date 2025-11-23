import 'package:fpdart/fpdart.dart';
import 'package:vfxmoney/core/errors/failure.dart';
import 'package:vfxmoney/core/usecase/usecase.dart';
import 'package:vfxmoney/features/auth/domain/auth_repositories/auth_repository.dart';

class DeleteAccountUseCaseParams {
  final String otp;
  final String reason;

  DeleteAccountUseCaseParams({
    required this.otp,
    required this.reason,
  });
}

class UserDeleteAccountUseCase implements UseCase<void, DeleteAccountUseCaseParams> {
  final AuthRepository repository;

  UserDeleteAccountUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteAccountUseCaseParams params) async {
    return await repository.deleteAccount(
      otp: params.otp,
      reason: params.reason,
    );
  }
}
