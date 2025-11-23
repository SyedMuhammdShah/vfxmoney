import 'package:equatable/equatable.dart';
import 'package:vfxmoney/core/params/auth_params/auth_params.dart';
import 'package:vfxmoney/core/params/auth_params/login_params.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignUpEvent extends AuthEvent {
  final RegisterProfileParams params;

  const SignUpEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class LoginRequested extends AuthEvent {
  final LoginParams params;
  const LoginRequested(this.params);

  @override
  List<Object?> get props => [params];
}

class VerifyLoginOtpEvent extends AuthEvent {
  final String otp;
  final String email;

  const VerifyLoginOtpEvent({required this.otp, required this.email});

  @override
  List<Object?> get props => [otp, email];
}

class SendEmailOtpEvent extends AuthEvent {
  final String token;

  const SendEmailOtpEvent(this.token);

  @override
  List<Object?> get props => [token];
}

class UpdateProfileEvent extends AuthEvent {
  final UpdateProfileParams params;
  const UpdateProfileEvent(this.params);
}

class SendPhoneOtpEvent extends AuthEvent {
  final String token;

  const SendPhoneOtpEvent(this.token);

  @override
  List<Object?> get props => [token];
}

class VerifyEmailOtpEvent extends AuthEvent {
  final String otp;
  final String token;

  const VerifyEmailOtpEvent({required this.otp, required this.token});

  @override
  List<Object?> get props => [otp, token];
}

class VerifyPhoneOtpEvent extends AuthEvent {
  final String otp;
  final String token;

  const VerifyPhoneOtpEvent({required this.otp, required this.token});

  @override
  List<Object?> get props => [otp, token];
}

class LoadUserSessionEvent extends AuthEvent {}

class SubmitChangeNumberEvent extends AuthEvent {
  final String phone;
  const SubmitChangeNumberEvent(this.phone);

  @override
  List<Object> get props => [phone];
}
