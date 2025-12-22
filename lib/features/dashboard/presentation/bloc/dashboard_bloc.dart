import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vfxmoney/core/params/dashboard_params/card_details_params.dart';
import 'package:vfxmoney/features/dashboard/domain/dashboard_usecase/get_card_detail_usecase.dart';
import 'package:vfxmoney/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:vfxmoney/features/dashboard/presentation/bloc/dashboard_state.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  final GetCardDetailsUseCase useCase;

  CardBloc(this.useCase) : super(CardInitial()) {
    on<FetchCardDetails>((event, emit) async {
      emit(CardLoading());
      try {
        final data = await useCase(CardDetailsParams(cardId: event.cardId));
        emit(CardLoaded(data));
      } catch (e) {
        emit(CardError(e.toString()));
      }
    });
  }
}
