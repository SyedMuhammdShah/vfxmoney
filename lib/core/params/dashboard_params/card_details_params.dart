class CardDetailsParams {
  final int cardId;
  final String route;

  CardDetailsParams({required this.cardId, this.route = 'strada.card_details'});

  Map<String, dynamic> toJson() => {'card_id': cardId, 'route': route};
}
