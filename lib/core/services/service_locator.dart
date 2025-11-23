import 'package:get_it/get_it.dart';
import 'package:vfxmoney/core/constants/api_endpoints.dart';
import 'package:vfxmoney/core/services/socket_service.dart';
import 'package:vfxmoney/features/auth/data/auth_datasource/auth_datascource.dart';
import 'package:vfxmoney/features/auth/data/auth_datasource/social_datasource.dart';
import 'package:vfxmoney/features/auth/data/auth_repositories_impl/auth_repository_impl.dart';
import 'package:vfxmoney/features/auth/data/auth_repositories_impl/social_repository_impl.dart';
import 'package:vfxmoney/features/auth/domain/auth_usecases/change_phone_number_usecase.dart';
import 'package:vfxmoney/features/auth/domain/auth_usecases/delete_account_usecase.dart';
import 'package:vfxmoney/features/auth/domain/auth_usecases/login_usecase.dart';
import 'package:vfxmoney/features/auth/domain/auth_usecases/send_delete_otp_usecase.dart';

import 'package:vfxmoney/features/auth/domain/auth_usecases/social_usecase.dart';
import 'package:vfxmoney/features/auth/domain/auth_usecases/update_profile_usecase.dart';
import 'package:vfxmoney/features/auth/domain/auth_usecases/verify_login_otp_usecase.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/delete_bloc/delete_account_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vfxmoney/features/auth/domain/auth_repositories/auth_repository.dart';
import 'package:vfxmoney/features/auth/domain/auth_usecases/send_email_otp_usecase.dart';
import 'package:vfxmoney/features/auth/domain/auth_usecases/send_phone_otp_usecase.dart';
import 'package:vfxmoney/features/auth/domain/auth_usecases/sign_up_usecase.dart';
import 'package:vfxmoney/features/auth/domain/auth_usecases/verify_email_otp_usecase.dart';
import 'package:vfxmoney/features/auth/domain/auth_usecases/verify_phone_otp_usecase.dart';
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
}

void _registerDataSources() {
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiService: locator()),
  );
  locator.registerLazySingleton<SocialDatasource>(() => SocialDatasourceImpl());
}

void _registerRepositories() {
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: locator()),
  );
  locator.registerLazySingleton<SocialRepositoryInternal>(
    () => SocialRepositoryImpl(locator<SocialDatasource>()),
  );
}

void _registerUseCases() {
  locator.registerLazySingleton(() => SignUpUseCase(locator()));
  locator.registerLazySingleton(() => LoginUseCase(repository: locator()));
  locator.registerLazySingleton(
    () => VerifyLoginOtpUseCase(repository: locator()),
  );
  locator.registerLazySingleton(() => SendEmailOtpUseCase(locator()));
  locator.registerLazySingleton(() => SendPhoneOtpUseCase(locator()));
  locator.registerLazySingleton(() => VerifyEmailOtpUseCase(locator()));
  locator.registerLazySingleton(() => VerifyPhoneOtpUseCase(locator()));
  locator.registerLazySingleton(() => UpdateProfileUseCase(locator()));
  locator.registerLazySingleton(() => SendDeleteOtpUseCase(locator()));
  locator.registerLazySingleton(() => UserDeleteAccountUseCase(locator()));
  locator.registerLazySingleton(() => ChangePhoneNumberUseCase(locator()));

  locator.registerLazySingleton(
    () => SocialSignInUseCase(locator<SocialRepositoryInternal>()),
  );
  locator.registerLazySingleton(
    () => UpdateFcmUseCase(locator<SocialRepositoryInternal>()),
  );
  locator.registerLazySingleton(
    () => SocialRegisterUseCase(locator<SocialRepositoryInternal>()),
  );
  locator.registerLazySingleton(
    () => SocialOTPUseCase(locator<SocialRepositoryInternal>()),
  );
  locator.registerLazySingleton(
    () => SendSocialOTPUseCase(locator<SocialRepositoryInternal>()),
  );
  locator.registerLazySingleton(
    () => DeleteAccountUseCase(locator<SocialRepositoryInternal>()),
  );
  locator.registerLazySingleton(
    () => LogoutUseCase(locator<SocialRepositoryInternal>()),
  );
}

void _registerBlocs() {
  locator.registerFactory(
    () => AuthBloc(
      loginUseCase: locator(),
      signUpUseCase: locator(),
      verifyLoginOtpUseCase: locator(),
      sendEmailOtpUseCase: locator(),
      sendPhoneOtpUseCase: locator(),
      verifyEmailOtpUseCase: locator(),
      verifyPhoneOtpUseCase: locator(),
      updateProfileUseCase: locator(),
      changePhoneNumberUseCase: locator(),
    ),
  );

  locator.registerFactory(
    () => DeleteAccountBloc(
      sendOtpUseCase: locator(),
      deleteAccountUseCase: locator(),
    ),
  );
}

Future<void> resetLocator() async {
  await locator.reset();
  await setupLocator();
}
