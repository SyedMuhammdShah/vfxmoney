class AddCardParams {
  final String paymentMethodId;
  final String name;

  AddCardParams({required this.paymentMethodId, required this.name});

  Map<String, dynamic> toJson() {
    return {'paymentMethodId': paymentMethodId, 'name': name};
  }
}

class UpdateCardParams {
  final String cardId;
  final String paymentMethodId;
  final String name;

  UpdateCardParams({
    required this.cardId,
    required this.paymentMethodId,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {'paymentMethodId': paymentMethodId, 'name': name};
  }
}

class GetCardParams {
  final int page;

  const GetCardParams({required this.page});
  Map<String, dynamic> toMap() {
    return {'page': page};
  }
}
