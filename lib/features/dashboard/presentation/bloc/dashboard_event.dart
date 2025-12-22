abstract class CardEvent {}

class FetchCardDetails extends CardEvent {
  final int cardId;

  FetchCardDetails(this.cardId);
}
