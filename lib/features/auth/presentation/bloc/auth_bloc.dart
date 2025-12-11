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

      // If server marks account as pending (e.g., needs email verification),
      // emit AuthOtpSent so UI can show OTP dialog.
      final String status = (user.status ?? '').toLowerCase();
      if (status == 'pending') {
        emit(
          AuthOtpSent(
            user: user,
            message: 'Account pending — please verify OTP',
          ),
        );
      } else {
        emit(AuthSuccess(user: user));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }
}
