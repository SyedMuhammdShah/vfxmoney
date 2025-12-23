import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vfxmoney/features/dashboard/domain/dashboard_usecase/get_cards_usecase.dart';
import 'package:vfxmoney/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:vfxmoney/features/dashboard/presentation/bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetCardsUseCase getCardsUseCase;

  DashboardBloc(this.getCardsUseCase) : super(CardLoading()) {
    on<FetchCards>(_fetchCards);
    on<CardPageChanged>(_changePage);
  }

  Future<void> _fetchCards(FetchCards event, Emitter emit) async {
    emit(CardLoading());
    final cards = await getCardsUseCase(event.linkId);
    emit(CardLoaded(cards, 0));
  }

  void _changePage(CardPageChanged event, Emitter emit) {
    final state = this.state as CardLoaded;
    emit(CardLoaded(state.cards, event.index));
  }
}
