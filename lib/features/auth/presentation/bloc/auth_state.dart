import 'package:equatable/equatable.dart';
import 'package:vfxmoney/features/auth/domain/auth_entities/auth_user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserEntity user;
  const AuthSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthOtpSent extends AuthState {
  final String message;
  const AuthOtpSent({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthFailure extends AuthState {
  final String error;
  const AuthFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
