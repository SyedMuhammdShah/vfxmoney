import 'package:fpdart/fpdart.dart';
import 'package:vfxmoney/core/errors/failure.dart';
import 'package:vfxmoney/core/params/auth_params/login_params.dart';
import 'package:vfxmoney/core/usecase/usecase.dart';
import 'package:vfxmoney/features/auth/domain/auth_repositories/auth_repository.dart';

class LoginUseCase implements UseCase<void, LoginParams> {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(LoginParams params) {
    return repository.login(params);
  }
}
