import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
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
    debugPrint('========================================');
    debugPrint('[AuthBloc] LoginRequested');
    debugPrint('========================================');

    emit(AuthLoading());
    debugPrint('[AuthBloc] ✅ Emitted AuthLoading');

    try {
      final params = LoginParams(email: event.email, password: event.password);
      final user = await loginUseCase(params);

      debugPrint('========================================');
      debugPrint('[AuthBloc] User received:');
      debugPrint('[AuthBloc] - Email: ${user.email}');
      debugPrint('[AuthBloc] - Status: "${user.status}"');
      debugPrint('[AuthBloc] - OTP Code: ${user.emailVerificationCode}');
      debugPrint('========================================');

      final String status = (user.status ?? '').toLowerCase().trim();
      debugPrint('[AuthBloc] Normalized status: "$status"');

      if (status == 'pending') {
        debugPrint('[AuthBloc] ✅ Emitting AuthOtpSent');
        emit(
          AuthOtpSent(
            user: user,
            message: 'Account pending — please verify OTP',
          ),
        );
        debugPrint('[AuthBloc] ✅ AuthOtpSent emitted successfully');
      } else {
        debugPrint('[AuthBloc] ✅ Emitting AuthSuccess');
        emit(AuthSuccess(user: user));
      }
    } catch (e, st) {
      debugPrint('[AuthBloc] ❌ ERROR: $e');
      debugPrint('[AuthBloc] StackTrace: $st');
      emit(AuthFailure(error: e.toString()));
    }
  }
}
