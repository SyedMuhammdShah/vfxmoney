class CardBalanceEntity {
  final double availableBalanceAmount;
  final double actualBalanceAmount;
  final double pendingBalanceAmount;
  final double blockedBalanceAmount;
  final String currency;

  const CardBalanceEntity({
    required this.availableBalanceAmount,
    required this.actualBalanceAmount,
    required this.pendingBalanceAmount,
    required this.blockedBalanceAmount,
    required this.currency,
  });
}
