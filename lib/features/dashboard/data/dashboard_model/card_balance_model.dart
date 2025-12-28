import 'package:vfxmoney/features/dashboard/domain/dashboard_entity/card_balance_entity.dart';

class CardBalanceModel extends CardBalanceEntity {
  const CardBalanceModel({
    required super.availableBalanceAmount,
    required super.actualBalanceAmount,
    required super.pendingBalanceAmount,
    required super.blockedBalanceAmount,
    required super.currency,
  });

  factory CardBalanceModel.fromJson(Map<String, dynamic> json) {
    return CardBalanceModel(
      availableBalanceAmount: (json['availableBalanceAmount'] ?? 0).toDouble(),
      actualBalanceAmount: (json['actualBalanceAmount'] ?? 0).toDouble(),
      pendingBalanceAmount: (json['pendingBalanceAmount'] ?? 0).toDouble(),
      blockedBalanceAmount: (json['blockedBalanceAmount'] ?? 0).toDouble(),
      currency: json['currency'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'availableBalanceAmount': availableBalanceAmount,
      'actualBalanceAmount': actualBalanceAmount,
      'pendingBalanceAmount': pendingBalanceAmount,
      'blockedBalanceAmount': blockedBalanceAmount,
      'currency': currency,
    };
  }
}
