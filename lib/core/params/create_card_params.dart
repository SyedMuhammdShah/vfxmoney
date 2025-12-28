class CreateCardParams {
  final String email;
  final String alias;
  final int cardHolderId;
  final String cardType;

  CreateCardParams({
    required this.email,
    required this.alias,
    required this.cardHolderId,
    required this.cardType,
  });

  Map<String, dynamic> toJson() {
    return {
      'route': 'strada.create_card',
      'email': email,
      'alias': alias,
      'card_holder_id': cardHolderId,
      'card_type': cardType,
    };
  }
}
