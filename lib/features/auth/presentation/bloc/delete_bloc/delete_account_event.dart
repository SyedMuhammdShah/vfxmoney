part of 'delete_account_bloc.dart';

abstract class DeleteAccountEvent extends Equatable {
  const DeleteAccountEvent();

  @override
  List<Object?> get props => [];
}

class SendDeleteOtpEvent extends DeleteAccountEvent {
  final String token;
  const SendDeleteOtpEvent(this.token);

  @override
  List<Object?> get props => [token];
}

class SubmitDeleteAccountEvent extends DeleteAccountEvent {
  final String otp;
  final String reason;

  const SubmitDeleteAccountEvent({
    required this.otp,
    required this.reason,
  });

  @override
  List<Object?> get props => [otp, reason];
}
