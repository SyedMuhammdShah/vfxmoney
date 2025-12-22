import 'package:vfxmoney/features/dashboard/domain/dashboard_entity/card_details_entity.dart';

abstract class CardState {}

class CardInitial extends CardState {}

class CardLoading extends CardState {}

class CardLoaded extends CardState {
  final CardDetailsEntity details;
  CardLoaded(this.details);
}

class CardError extends CardState {
  final String message;
  CardError(this.message);
}
