import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vfxmoney/features/dashboard/domain/dashboard_usecase/get_cards_usecase.dart';
import 'package:vfxmoney/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:vfxmoney/features/dashboard/presentation/bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetCardsUseCase getCards;

  DashboardBloc(this.getCards) : super(DashboardLoading()) {
    on<FetchCards>(_onFetch);
    on<CardChanged>(_onCardChanged);
  }

  Future<void> _onFetch(FetchCards event, Emitter emit) async {
    emit(DashboardLoading());

    final cards = await getCards(event.linkId);

    emit(DashboardLoaded(cards: cards, activeIndex: 0));
  }

  void _onCardChanged(CardChanged event, Emitter emit) {
    final current = state as DashboardLoaded;
    emit(DashboardLoaded(cards: current.cards, activeIndex: event.index));
  }
}
