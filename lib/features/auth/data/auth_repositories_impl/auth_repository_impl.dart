import 'package:vfxmoney/core/params/auth_params/auth_params.dart';
import 'package:vfxmoney/features/auth/data/auth_datasource/auth_datascource.dart';
import 'package:vfxmoney/features/auth/data/auth_model/auth_user_model.dart';
import 'package:vfxmoney/features/auth/domain/auth_entities/auth_user_entity.dart';
import 'package:vfxmoney/features/auth/domain/auth_repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> login(LoginParams params) async {
    final AuthUserModel model = await remoteDataSource.login(params);
    return model.toEntity();
  }

  @override
  Future<String> register(RegisterParams params) {
    return remoteDataSource.register(params);
  }

  @override
  Future<UserEntity> verifyEmailOtp(VerifyEmailOtpParams params, String token) async {
    final model = await remoteDataSource.verifyEmailOtp(params, token);
    return model.toEntity();
  }
}
