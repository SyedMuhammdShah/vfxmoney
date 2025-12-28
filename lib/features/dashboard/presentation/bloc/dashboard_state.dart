import 'package:vfxmoney/features/dashboard/domain/dashboard_entity/card_details_entity.dart';
import 'package:vfxmoney/features/dashboard/domain/dashboard_entity/card_entity.dart';

enum DashboardAction { none, cardCreated }

abstract class DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<CardHolderEntity> cards;
  final int activeIndex;
  // Balance
  final bool isBalanceVisible;
  final String? visibleBalance;
  final String? currency;

  // Card details 👇
  final bool isCardDetailsVisible;
  final CardDetailsEntity? cardDetails;

  final DashboardAction lastAction;
  final String? message;
  DashboardLoaded({
    required this.cards,
    required this.activeIndex,
    this.isBalanceVisible = false,
    this.visibleBalance,
    this.currency,
    this.isCardDetailsVisible = false,
    this.cardDetails,
    this.lastAction = DashboardAction.none,
    this.message,
  });

  CardHolderEntity get activeCard => cards[activeIndex];
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}
