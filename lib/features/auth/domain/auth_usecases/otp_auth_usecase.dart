import 'package:vfxmoney/core/params/auth_params/auth_params.dart';
import 'package:vfxmoney/features/auth/domain/auth_entities/auth_user_entity.dart';
import 'package:vfxmoney/features/auth/domain/auth_repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<UserEntity> call(VerifyEmailOtpParams params) {
    return repository.verifyEmailOtp(params);
  }
}
