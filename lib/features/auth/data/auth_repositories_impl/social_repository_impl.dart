import 'package:fpdart/fpdart.dart';
import 'package:vfxmoney/core/params/auth_params/auth_params.dart';
import 'package:vfxmoney/features/auth/data/auth_datasource/social_datasource.dart';
import 'package:vfxmoney/features/auth/domain/auth_entities/auth_user_entity.dart';
import 'package:vfxmoney/features/auth/domain/auth_repositories/social_repositories.dart';

import '../../../../core/errors/failure.dart';

abstract class SocialRepositoryInternal
    implements
        SocialLoginRepository,
        UpdateFcmRepository,
        SocialRegisterRepository,
        SocialOTPRepository,
        SendSocialOTPRepository,
        DeleteAccountRepository,
        LogoutRepository {}

class SocialRepositoryImpl implements SocialRepositoryInternal {
  final SocialDatasource dataSource;

  const SocialRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, AuthUserEntity>> socialLogin({
    required SocialSignInParam params,
  }) async {
    final socialSignInResponse = await dataSource.socialSignIn(params);

    return socialSignInResponse.fold(
      (left) => Left(ServerFailure(left.message)),
      (right) => Right(right),
    );
  }

  @override
  Future<Either<Failure, AuthUserEntity>> socialRegister({
    required SocialRegisterParam params,
  }) async {
    final socialSignInResponse = await dataSource.socialRegister(params);

    return socialSignInResponse.fold(
      (left) => Left(ServerFailure(left.message)),
      (right) => Right(right),
    );
  }

  @override
  Future<Either<Failure, AuthUserEntity>> socialOTP({
    required SocialOTPParam params,
  }) async {
    final socialSignInResponse = await dataSource.socialOTP(params);

    return socialSignInResponse.fold(
      (left) => Left(ServerFailure(left.message)),
      (right) => Right(right),
    );
  }

  @override
  Future<Either<Failure, void>> sendSocialOTP() async {
    final result = await dataSource.sendSocialOTP();

    return result.fold(
      (left) => Left(ServerFailure(left.message)),
      (right) => const Right(null),
    );
  }

  @override
  Future<Either<Failure, String>> updateFcm({
    required UpdateFcmParams params,
  }) async {
    final res = await dataSource.updateFcmToken(params: params);
    return res.fold(
      (left) => Left(ServerFailure(left.message)),
      (right) => Right(right),
    );
  }

  @override
  Future<Either<Failure, String>> logout() async {
    final logout = await dataSource.logout();

    return logout.fold(
      (left) => Left(ServerFailure(left.message)),
      (right) => Right(right),
    );
  }

  @override
  Future<Either<Failure, String>> deleteAccount() async {
    final logout = await dataSource.deleteAccount();

    return logout.fold(
      (left) => Left(ServerFailure(left.message)),
      (right) => Right(right),
    );
  }
}
