import 'package:vfxmoney/features/dashboard/domain/dashboard_entity/card_entity.dart';

abstract class DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<CardHolderEntity> cards;
  final int activeIndex;

  DashboardLoaded({required this.cards, required this.activeIndex});

  CardHolderEntity get activeCard => cards[activeIndex];
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}
