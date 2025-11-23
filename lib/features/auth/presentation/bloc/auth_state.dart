import 'package:equatable/equatable.dart';
import 'package:vfxmoney/features/auth/domain/auth_entities/auth_user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];

  get result => null;
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

// Single consolidated authenticated state that holds the current user
class Authenticated extends AuthState {
  final AuthUserEntity authUser;

  const Authenticated(this.authUser);

  @override
  List<Object?> get props => [authUser];

  // Helper getters
  bool get needsEmailVerification => !authUser.user!.isEmailVerified;
  bool get needsPhoneVerification => !authUser.user!.isPhoneVerified;
  bool get isFullyVerified =>
      (authUser.user?.isEmailVerified ?? false) &&
      (authUser.user?.isPhoneVerified ?? false);

  Authenticated copyWith({AuthUserEntity? authUser}) {
    return Authenticated(authUser ?? this.authUser);
  }
}

class OtpSending extends AuthState {
  final String verificationType; // 'email' or 'phone'

  const OtpSending(this.verificationType);

  @override
  List<Object?> get props => [verificationType];
}

class OtpSent extends AuthState {
  final String message;
  final String verificationType;

  const OtpSent({required this.message, required this.verificationType});

  @override
  List<Object?> get props => [message, verificationType];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class SendEmailOtpSuccess extends AuthState {
  final String message;
  const SendEmailOtpSuccess(this.message);
}

class SendEmailOtpFailure extends AuthState {
  final String message;
  const SendEmailOtpFailure(this.message);
}

class SendPhoneOtpSuccess extends AuthState {
  final String message;
  const SendPhoneOtpSuccess(this.message);
}

class SendPhoneOtpFailure extends AuthState {
  final String message;
  const SendPhoneOtpFailure(this.message);
}

class LoginOtpSent extends AuthState {
  final String message;
  final String email; // Store email for later use

  const LoginOtpSent({required this.message, required this.email});

  @override
  List<Object?> get props => [message, email];
}

class RedirectToVerifyAccount extends AuthState {
  final AuthUserEntity user;
  final String verificationType; // "email" or "phone"
  final String source; // "login" or "splash"

  const RedirectToVerifyAccount({
    required this.user,
    required this.verificationType,
    required this.source,
  });
}

class RedirectToHome extends AuthState {
  final AuthUserEntity user;
  const RedirectToHome(this.user);
}

class ProfileUpdated extends AuthState {
  final AuthUserEntity user;
  const ProfileUpdated(this.user);
}

class ChangeNumberInitial extends AuthState {}

class ChangeNumberLoading extends AuthState {}

class ChangeNumberSuccess extends AuthState {}

class ChangeNumberError extends AuthState {
  final String message;
  const ChangeNumberError(this.message);

  @override
  List<Object> get props => [message];
}

