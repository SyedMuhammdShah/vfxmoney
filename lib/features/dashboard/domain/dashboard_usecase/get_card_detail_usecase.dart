import 'package:vfxmoney/features/dashboard/domain/dashboard_entity/card_details_entity.dart';
import 'package:vfxmoney/features/dashboard/domain/dashboard_repo/dashboard_repo.dart';

class GetCardDetailsUseCase {
  final DashboardRepo repo;

  GetCardDetailsUseCase(this.repo);

  Future<CardDetailsEntity> call(int cardId) {
    return repo.getCardDetails(cardId);
  }
}
