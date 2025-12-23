import 'package:vfxmoney/features/dashboard/domain/dashboard_entity/card_entity.dart';

abstract class DashboardState {}

class CardLoading extends DashboardState {}

class CardLoaded extends DashboardState {
  final List<CardHolderEntity> cards;
  final int currentIndex;

  CardLoaded(this.cards, this.currentIndex);
}

class CardError extends DashboardState {
  final String message;
  CardError(this.message);
}
