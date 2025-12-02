import 'package:bloc/bloc.dart';
import 'package:vfxmoney/core/params/auth_params/auth_params.dart';
import 'package:vfxmoney/features/auth/domain/auth_usecases/login_usecase.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/auth_events.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc({required this.loginUseCase}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final params = LoginParams(email: event.email, password: event.password);
      final user = await loginUseCase(params);

      // If server requires OTP flow, the remote may still return the user with otpRequired true.
      if (user.otpRequired == true) {
        emit(const AuthOtpSent(message: 'OTP sent. Please verify.'));
      } else {
        emit(AuthSuccess(user: user));
      }
    } catch (e) {
      final message = e is Exception ? e.toString() : 'Unknown error';
      emit(AuthFailure(error: message));
    }
  }
}
