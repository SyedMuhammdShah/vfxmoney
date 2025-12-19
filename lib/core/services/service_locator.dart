import 'package:get_it/get_it.dart';
import 'package:vfxmoney/core/constants/api_endpoints.dart';
import 'package:vfxmoney/core/services/jwt_encryption_service.dart';
import 'package:vfxmoney/core/services/socket_service.dart';
import 'package:vfxmoney/features/auth/data/auth_datasource/auth_datascource.dart';
import 'package:vfxmoney/features/auth/data/auth_datasource/auth_remote_datasource_impl.dart';
import 'package:vfxmoney/features/auth/data/auth_repositories_impl/auth_repository_impl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vfxmoney/features/auth/domain/auth_repositories/auth_repository.dart';
import 'package:vfxmoney/features/auth/domain/auth_usecases/login_usecase.dart';
import 'package:vfxmoney/features/auth/domain/auth_usecases/otp_auth_usecase.dart';
import 'package:vfxmoney/features/auth/domain/auth_usecases/signup_usecase.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vfxmoney/features/theme/bloc/theme_bloc.dart';

import 'api_service.dart';
import 'device_data_service.dart';
import 'firebase_service.dart';
import 'storage_service.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // Register Firebase Service
  locator.registerSingleton<FirebaseService>(FirebaseService());

  // Register SharedPreferences (async)
  locator.registerSingletonAsync<SharedPreferences>(
    () async => await SharedPreferences.getInstance(),
  );
  await locator.isReady<SharedPreferences>();

  // Register Storage Service
  locator.registerLazySingleton<StorageService>(
    () => StorageService(locator<SharedPreferences>()),
  );

  // Register Socket Service
  locator.registerLazySingleton<SocketService>(
    () => SocketService(locator<StorageService>()),
  );

  // Application Theme
  locator.registerLazySingleton<ThemeBloc>(() => ThemeBloc());

  // Register DeviceInfoService (async) and WAIT for it
  locator.registerSingletonAsync<DeviceInfoService>(() async {
    final service = DeviceInfoService();
    await service.init();
    return service;
  });
  await locator.isReady<DeviceInfoService>();

  // Register ApiService - Use the const baseUrl directly
  locator.registerLazySingleton(() => ApiService(baseUrl: baseUrl));

  // Register all other dependencies
  _registerDataSources();
  _registerRepositories();
  _registerUseCases();
  _registerBlocs();

  locator.registerLazySingleton<JwtEncryptionService>(
    () => JwtEncryptionService(
      'base64:iSjTxaW/XnHORfscv2g0nkpI98jOoU582y0lj91m2dA=',
    ),
  );
}

// Data sources
void _registerDataSources() {
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiService: locator<ApiService>()),
  );
}

// Repositories
void _registerRepositories() {
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: locator()),
  );
}

// Usecases
void _registerUseCases() {
  locator.registerLazySingleton(() => LoginUseCase(locator<AuthRepository>()));
  locator.registerLazySingleton(() => RegisterUseCase(locator<AuthRepository>()));
  locator.registerLazySingleton(
    () => VerifyOtpUseCase(locator<AuthRepository>()),
  );
}

// Bloc (factory so new instance per consumer)
void _registerBlocs() {
  locator.registerFactory(
    () => AuthBloc(
      loginUseCase: locator<LoginUseCase>(),
      registerUseCase: locator<RegisterUseCase>(),
      verifyOtpUseCase: locator<VerifyOtpUseCase>(),
    ),
  );
}
// JwtEncryptionService (if not already)

Future<void> resetLocator() async {
  await locator.reset();
  await setupLocator();
}
