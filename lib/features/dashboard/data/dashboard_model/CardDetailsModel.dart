import 'package:vfxmoney/features/dashboard/domain/dashboard_entity/card_details_entity.dart';

class CardDetailsModel extends CardDetailsEntity {
  CardDetailsModel({
    required super.cardNumber,
    required super.expMonth,
    required super.expYear,
    required super.cvv,
  });

  factory CardDetailsModel.fromJson(Map<String, dynamic> json) {
    return CardDetailsModel(
      cardNumber: json['cardNumber']?.toString() ?? '',
      expMonth: json['expMonth']?.toString() ?? '',
      expYear: json['expYear']?.toString() ?? '',
      cvv: json['cvv']?.toString() ?? '',
    );
  }
}
