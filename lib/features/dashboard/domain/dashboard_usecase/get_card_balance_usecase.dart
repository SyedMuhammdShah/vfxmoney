import 'package:vfxmoney/features/dashboard/domain/dashboard_entity/card_balance_entity.dart';
import 'package:vfxmoney/features/dashboard/domain/dashboard_repo/dashboard_repo.dart';

class GetCardBalanceUseCase {
  final DashboardRepo repo;

  GetCardBalanceUseCase(this.repo);

  Future<CardBalanceEntity> call(int cardId, int cardHolderId) {
    return repo.getCardBalance(cardId, cardHolderId);
  }
}
