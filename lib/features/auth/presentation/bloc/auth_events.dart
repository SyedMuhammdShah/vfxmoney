import 'package:equatable/equatable.dart';
import 'package:vfxmoney/core/params/auth_params/auth_params.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

// New Event for Registration
class RegisterRequested extends AuthEvent {
  final RegisterParams params;

  const RegisterRequested({required this.params});

  @override
  List<Object?> get props => [params];
}

// OTP Verification Event
class VerifyOtpRequested extends AuthEvent {
  final String email;
  final String code;

  const VerifyOtpRequested({required this.email, required this.code});

  @override
  List<Object?> get props => [email, code];
}
