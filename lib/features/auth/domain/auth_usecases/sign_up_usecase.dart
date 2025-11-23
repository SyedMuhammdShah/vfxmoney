

import 'package:fpdart/fpdart.dart';
import 'package:vfxmoney/core/errors/failure.dart';
import 'package:vfxmoney/core/params/auth_params/auth_params.dart';
import 'package:vfxmoney/features/auth/domain/auth_entities/auth_user_entity.dart';
import 'package:vfxmoney/features/auth/domain/auth_repositories/auth_repository.dart';
import 'package:vfxmoney/core/usecase/usecase.dart';


class SignUpUseCase implements UseCase<AuthUserEntity, RegisterProfileParams> {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  @override
  Future<Either<Failure, AuthUserEntity>> call(
      RegisterProfileParams params) async {
    return await repository.signUp(params);
  }
}
