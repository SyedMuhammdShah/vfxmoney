import 'package:bloc/bloc.dart';
import 'package:vfxmoney/core/params/auth_params/verify_login_params.dart';
import 'package:vfxmoney/core/services/service_locator.dart';
import 'package:vfxmoney/core/services/storage_service.dart';
import 'package:vfxmoney/features/auth/data/auth_model/auth_user_model.dart';
import 'package:vfxmoney/features/auth/domain/auth_entities/auth_user_entity.dart';
import 'package:vfxmoney/features/auth/domain/auth_usecases/change_phone_number_usecase.dart';
import 'package:vfxmoney/features/auth/domain/auth_usecases/login_usecase.dart';
import 'package:vfxmoney/features/auth/domain/auth_usecases/send_email_otp_usecase.dart';
import 'package:vfxmoney/features/auth/domain/auth_usecases/send_phone_otp_usecase.dart';
import 'package:vfxmoney/features/auth/domain/auth_usecases/sign_up_usecase.dart';
import 'package:vfxmoney/features/auth/domain/auth_usecases/update_profile_usecase.dart';
import 'package:vfxmoney/features/auth/domain/auth_usecases/verify_email_otp_usecase.dart';
import 'package:vfxmoney/features/auth/domain/auth_usecases/verify_login_otp_usecase.dart';
import 'package:vfxmoney/features/auth/domain/auth_usecases/verify_phone_otp_usecase.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/auth_events.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase signUpUseCase;
  final LoginUseCase loginUseCase;
  final VerifyLoginOtpUseCase verifyLoginOtpUseCase;
  final SendEmailOtpUseCase sendEmailOtpUseCase;
  final SendPhoneOtpUseCase sendPhoneOtpUseCase;
  final VerifyEmailOtpUseCase verifyEmailOtpUseCase;
  final VerifyPhoneOtpUseCase verifyPhoneOtpUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final ChangePhoneNumberUseCase changePhoneNumberUseCase;

  final StorageService storageService = locator<StorageService>();

  // Keep current user in memory
  AuthUserEntity? _currentUser;
  String? _loginEmail;
  AuthBloc({
    required this.signUpUseCase,
    required this.loginUseCase,
    required this.verifyLoginOtpUseCase,
    required this.sendEmailOtpUseCase,
    required this.sendPhoneOtpUseCase,
    required this.verifyEmailOtpUseCase,
    required this.verifyPhoneOtpUseCase,
    required this.updateProfileUseCase,
    required this.changePhoneNumberUseCase,
  }) : super(AuthInitial()) {
    on<SignUpEvent>(_onSignUp);
    on<LoginRequested>(_onLogin);
    on<VerifyLoginOtpEvent>(_onVerifyLoginOtp);
    on<SendEmailOtpEvent>(_onSendEmailOtp);
    on<SendPhoneOtpEvent>(_onSendPhoneOtp);
    on<VerifyEmailOtpEvent>(_onVerifyEmailOtp);
    on<VerifyPhoneOtpEvent>(_onVerifyPhoneOtp);
    on<LoadUserSessionEvent>(_onLoadUserSession);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<SubmitChangeNumberEvent>(_onChangePhoneNumber);
  }

  Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    _loginEmail = event.params.email; // Store email

    final result = await loginUseCase(event.params);

    result.fold((failure) => emit(AuthError(failure.message)), (_) {
      // OTP sent successfully
      emit(
        LoginOtpSent(message: 'OTP sent to your email', email: _loginEmail!),
      );
    });
  }

  Future<void> _onLoadUserSession(
    LoadUserSessionEvent event,
    Emitter<AuthState> emit,
  ) async {
    await Future.delayed(const Duration(seconds: 1)); // splash delay

    final token = storageService.getToken;
    final user = storageService.getUser;

    if (token == null || token.isEmpty || user == null) {
      emit(AuthInitial()); // not logged in
      return;
    }

    final authEntity = AuthUserEntity(token: token, user: user);
    _currentUser = authEntity;

    emit(Authenticated(authEntity));
  }

  Future<void> _onVerifyLoginOtp(
    VerifyLoginOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await verifyLoginOtpUseCase(
      VerifyLoginOtpParams(otp: event.otp, email: event.email, role: "user"),
    );

    await result.fold(
      (failure) async {
        emit(AuthError(failure.message));
      },
      (authUser) async {
        _currentUser = authUser;
        _loginEmail = null;

        await storageService.setToken(authUser.token);

        if (authUser.user != null) {
          final userModel = UserModel.fromEntity(authUser.user!);
          await storageService.setUser(userModel.toJson());
        }

        // ✅ determine redirection logic safely (no async gap after emit)
        final user = authUser.user;
        if (user != null) {
          if (user.isEmailVerified && user.isPhoneVerified) {
            emit(RedirectToHome(authUser));
          } else {
            emit(
              RedirectToVerifyAccount(
                source: 'login',
                verificationType: user.isEmailVerified ? 'phone' : 'email',
                user: authUser,
              ),
            );
          }
        } else {
          emit(AuthError('User data not found'));
        }
      },
    );
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signUpUseCase(event.params);

    result.fold((failure) => emit(AuthError(failure.message)), (authUser) {
      _currentUser = authUser;
      storageService.setToken(authUser.token);
      if (authUser.user != null) {
        final userModel = UserModel.fromEntity(authUser.user!);
        storageService.setUser(userModel.toJson());
      }
      emit(Authenticated(authUser));
    });
  }

  Future<void> _onSendEmailOtp(
    SendEmailOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (_currentUser == null) {
      emit(const AuthError('User session not found'));
      return;
    }

    emit(const OtpSending('email'));

    final result = await sendEmailOtpUseCase(_currentUser!.token);

    result.fold(
      (failure) {
        emit(AuthError(failure.message));
        emit(Authenticated(_currentUser!));
      },
      (_) => emit(
        const OtpSent(
          message: 'OTP sent to email successfully',
          verificationType: 'email',
        ),
      ),
    );
  }

  Future<void> _onSendPhoneOtp(
    SendPhoneOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (_currentUser == null) {
      emit(const AuthError('User session not found'));
      return;
    }

    emit(const OtpSending('phone'));

    final result = await sendPhoneOtpUseCase(_currentUser!.token);

    result.fold(
      (failure) {
        emit(AuthError(failure.message));
        emit(Authenticated(_currentUser!));
      },
      (_) => emit(
        const OtpSent(
          message: 'OTP sent to phone successfully',
          verificationType: 'phone',
        ),
      ),
    );
  }

  Future<void> _onVerifyEmailOtp(
    VerifyEmailOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (_currentUser == null) {
      emit(const AuthError('User session not found'));
      return;
    }

    emit(AuthLoading());

    final result = await verifyEmailOtpUseCase(
      VerifyEmailOtpParams(otp: event.otp, token: _currentUser!.token),
    );

    result.fold((failure) => emit(AuthError(failure.message)), (authUser) {
      // emit updated state
      if (authUser.user != null) {
        final userModel = UserModel.fromEntity(authUser.user!);
        storageService.setUser(userModel.toJson());
      }
      emit(Authenticated(authUser));
    });
  }

  Future<void> _onVerifyPhoneOtp(
    VerifyPhoneOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (_currentUser == null) {
      emit(const AuthError('User session not found on'));
      return;
    }

    emit(AuthLoading());

    final result = await verifyPhoneOtpUseCase(
      VerifyPhoneOtpParams(otp: event.otp, token: _currentUser!.token),
    );

    result.fold((failure) => emit(AuthError(failure.message)), (authUser) {
      if (authUser.user != null) {
        final userModel = UserModel.fromEntity(authUser.user!);
        storageService.setUser(userModel.toJson());
      }
      // emit updated state
      emit(Authenticated(authUser));
    });
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await updateProfileUseCase(event.params);

    result.fold((failure) => emit(AuthError(failure.message)), (
      authUser,
    ) async {
      _currentUser = authUser;

      if (authUser.user != null) {
        final userModel = UserModel.fromEntity(authUser.user!);
        await storageService.setUser(userModel.toJson());
      }

      emit(ProfileUpdated(authUser));
    });
  }

  Future<void> _onChangePhoneNumber(
    SubmitChangeNumberEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(ChangeNumberLoading());
    final result = await changePhoneNumberUseCase(event.phone);

    result.fold((failure) {
      if (failure.message.contains("Unauthorized")) {
        emit(ChangeNumberError("Session expired. Please log in again."));
      } else {
        emit(ChangeNumberError(failure.message));
      }
    }, (_) => emit(ChangeNumberSuccess()));
  }

  String? get loginEmail => _loginEmail;
  AuthUserEntity? get currentUser => _currentUser;
}
