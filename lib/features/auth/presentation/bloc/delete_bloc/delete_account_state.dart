  part of 'delete_account_bloc.dart';

  abstract class DeleteAccountState extends Equatable {
    const DeleteAccountState();

    @override
    List<Object?> get props => [];
  }

  class DeleteAccountInitial extends DeleteAccountState {}

  class DeleteAccountLoading extends DeleteAccountState {}

  class DeleteAccountOtpSent extends DeleteAccountState {}

  class DeleteAccountSuccess extends DeleteAccountState {}

  class DeleteAccountError extends DeleteAccountState {
    final String message;
    const DeleteAccountError(this.message);

    @override
    List<Object?> get props => [message];
  }
