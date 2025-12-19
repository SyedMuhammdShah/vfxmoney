import 'package:vfxmoney/core/params/auth_params/auth_params.dart';
import 'package:vfxmoney/features/auth/domain/auth_repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<String> call(RegisterParams params) {
    return repository.register(params);
  }
}
