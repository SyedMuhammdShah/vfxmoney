import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vfxmoney/features/auth/domain/auth_usecases/delete_account_usecase.dart';
import 'package:vfxmoney/features/auth/domain/auth_usecases/send_delete_otp_usecase.dart';

part 'delete_account_event.dart';
part 'delete_account_state.dart';

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  final SendDeleteOtpUseCase sendOtpUseCase;
  final UserDeleteAccountUseCase deleteAccountUseCase;

  DeleteAccountBloc({
    required this.sendOtpUseCase,
    required this.deleteAccountUseCase,
  }) : super(DeleteAccountInitial()) {
    on<SendDeleteOtpEvent>(_onSendOtp);
    on<SubmitDeleteAccountEvent>(_onDeleteAccount);
  }

  Future<void> _onSendOtp(
    SendDeleteOtpEvent event,
    Emitter<DeleteAccountState> emit,
  ) async {
    emit(DeleteAccountLoading());
    final result = await sendOtpUseCase(event.token);
    result.fold(
      (failure) => emit(DeleteAccountError(failure.message)),
      (_) => emit(DeleteAccountOtpSent()),
    );
  }

  Future<void> _onDeleteAccount(
    SubmitDeleteAccountEvent event,
    Emitter<DeleteAccountState> emit,
  ) async {
    emit(DeleteAccountLoading());
    final result = await deleteAccountUseCase(
      DeleteAccountUseCaseParams(otp: event.otp, reason: event.reason),
    );

    result.fold(
      (failure) => emit(DeleteAccountError(failure.message)),
      (_) => emit(DeleteAccountSuccess()),
    );
  }
}
