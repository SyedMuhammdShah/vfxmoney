abstract class DashboardEvent {}

class FetchCardDetails extends DashboardEvent {
  final int cardId;

  FetchCardDetails(this.cardId);
}

// Cards List Events
class FetchCards extends DashboardEvent {
  final int linkId;
  FetchCards(this.linkId);
}

class CardPageChanged extends DashboardEvent {
  final int index;
  CardPageChanged(this.index);
}
