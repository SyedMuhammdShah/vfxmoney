import 'package:fpdart/fpdart.dart';
import 'package:vfxmoney/core/errors/exceptions.dart';
import 'package:vfxmoney/core/errors/failure.dart';
import 'package:vfxmoney/core/params/auth_params/auth_params.dart';
import 'package:vfxmoney/core/params/auth_params/login_params.dart';
import 'package:vfxmoney/core/params/auth_params/verify_login_params.dart';
import 'package:vfxmoney/features/auth/data/auth_datasource/auth_datascource.dart';
import 'package:vfxmoney/features/auth/domain/auth_entities/auth_user_entity.dart';
import 'package:vfxmoney/features/auth/domain/auth_repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AuthUserEntity>> signUp(
    RegisterProfileParams params,
  ) async {
    try {
      final result = await remoteDataSource.signUp(params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> login(LoginParams params) async {
    try {
      final result = await remoteDataSource.login(params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthUserEntity>> verifyLoginOtp(
    VerifyLoginOtpParams params,
  ) async {
    try {
      final result = await remoteDataSource.verifyLoginOtp(params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendEmailOtp(String token) async {
    try {
      await remoteDataSource.sendEmailOtp(token);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendPhoneOtp(String token) async {
    try {
      await remoteDataSource.sendPhoneOtp(token);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendDeleteOtp(String token) async {
    try {
      await remoteDataSource.sendDeleteOtp(token);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthUserEntity>> verifyEmailOtp(
    String otp,
    String token,
  ) async {
    try {
      final result = await remoteDataSource.verifyEmailOtp(otp, token);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthUserEntity>> verifyPhoneOtp(
    String otp,
    String token,
  ) async {
    try {
      final result = await remoteDataSource.verifyPhoneOtp(otp, token);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthUserEntity>> updateProfile(
    UpdateProfileParams params,
  ) async {
    try {
      final result = await remoteDataSource.updateProfile(params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount({
    required String otp,
    required String reason,
  }) async {
    try {
      await remoteDataSource.deleteAccount(otp: otp, reason: reason);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePhoneNumber(String phone) async {
    try {
      await remoteDataSource.changePhoneNumber(phone);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message.toString()));
    } catch (_) {
      return Left(ServerFailure('Something went wrong while changing number.'));
    }
  }
}
