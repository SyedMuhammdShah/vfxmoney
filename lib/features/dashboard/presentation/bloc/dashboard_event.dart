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

class CardChanged extends DashboardEvent {
  final int index;
  CardChanged(this.index);
}

class FetchCardBalance extends DashboardEvent {
  final int cardId;
  final int cardHolderId;

  FetchCardBalance({required this.cardId, required this.cardHolderId});
}

// Create Card Event
class CreateCard extends DashboardEvent {
  final String alias;
  final String cardType;

  CreateCard({required this.alias, required this.cardType});
}
