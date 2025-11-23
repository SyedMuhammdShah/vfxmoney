import 'package:fpdart/fpdart.dart';
import 'package:vfxmoney/core/errors/failure.dart';
import 'package:vfxmoney/core/usecase/usecase.dart';
import 'package:vfxmoney/features/auth/domain/auth_repositories/auth_repository.dart';

class ChangePhoneNumberUseCase implements UseCase<void, String> {
  final AuthRepository repository;

  ChangePhoneNumberUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String phone) async {
    return await repository.changePhoneNumber(phone);
  }
}
