import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vfxmoney/features/dashboard/domain/dashboard_usecase/create_card_usecase.dart';
import 'package:vfxmoney/features/dashboard/domain/dashboard_usecase/get_card_balance_usecase.dart';
import 'package:vfxmoney/features/dashboard/domain/dashboard_usecase/get_card_detail_usecase.dart';
import 'package:vfxmoney/features/dashboard/domain/dashboard_usecase/get_cards_usecase.dart';
import 'package:vfxmoney/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:vfxmoney/features/dashboard/presentation/bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetCardsUseCase getCards;
  final GetCardBalanceUseCase getCardBalanceUseCase;
  final GetCardDetailsUseCase getCardDetails;
  final CreateCardUseCase createCardUseCase;

  DashboardBloc(
    this.getCards,
    this.getCardBalanceUseCase,
    this.getCardDetails,
    this.createCardUseCase,
  ) : super(DashboardLoading()) {
    on<FetchCards>(_onFetch);
    on<CardChanged>(_onCardChanged);
    on<FetchCardBalance>(_onFetchCardBalance);
    on<FetchCardDetails>(_onFetchCardDetails);
    on<CreateCard>(_onCreateCard);
  }

  // Fetch cards for a user
  Future<void> _onFetch(FetchCards event, Emitter emit) async {
    emit(DashboardLoading());

    final cards = await getCards(event.linkId);

    emit(DashboardLoaded(cards: cards, activeIndex: 0));
  }

  void _onCardChanged(CardChanged event, Emitter emit) {
    final current = state as DashboardLoaded;
    emit(
      DashboardLoaded(
        cards: current.cards,
        activeIndex: event.index,

        // reset everything
        isBalanceVisible: false,
        isCardDetailsVisible: false,
      ),
    );
  }

  // Fetch balance for a specific card
  Future<void> _onFetchCardBalance(
    FetchCardBalance event,
    Emitter<DashboardState> emit,
  ) async {
    final current = state as DashboardLoaded;

    // emit loading-like state but keep UI intact
    emit(
      DashboardLoaded(
        cards: current.cards,
        activeIndex: current.activeIndex,
        isBalanceVisible: false,
      ),
    );

    try {
      final balance = await getCardBalanceUseCase(
        event.cardId,
        event.cardHolderId,
      );

      emit(
        DashboardLoaded(
          cards: current.cards,
          activeIndex: current.activeIndex,
          isBalanceVisible: true,
          visibleBalance: balance.availableBalanceAmount.toString(),
          currency: balance.currency,
        ),
      );
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  // Card details fetch can be added here

  Future<void> _onFetchCardDetails(
    FetchCardDetails event,
    Emitter<DashboardState> emit,
  ) async {
    final current = state as DashboardLoaded;
    final details = await getCardDetails(event.cardId);

    emit(
      DashboardLoaded(
        cards: current.cards,
        activeIndex: current.activeIndex,

        // reset balance
        isBalanceVisible: false,

        // show card details
        isCardDetailsVisible: true,
        cardDetails: details,
      ),
    );
  }

  // Create Card
  Future<void> _onCreateCard(
    CreateCard event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final current = state as DashboardLoaded;

      await createCardUseCase(alias: event.alias, cardType: event.cardType);

      // ✅ EMIT SUCCESS SIGNAL
      emit(
        DashboardLoaded(
          cards: current.cards,
          activeIndex: current.activeIndex,
          lastAction: DashboardAction.cardCreated,
          message: 'Card created successfully',
        ),
      );

      // 🔄 REFRESH CARD LIST
      add(FetchCards(int.parse(current.cards.first.cardHolderId)));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
