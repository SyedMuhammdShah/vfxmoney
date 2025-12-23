import 'package:vfxmoney/features/dashboard/domain/dashboard_entity/card_entity.dart';
import 'package:vfxmoney/features/dashboard/domain/dashboard_repo/dashboard_repo.dart';

class GetCardsUseCase {
  final DashboardRepo repo;

  GetCardsUseCase(this.repo);

  Future<List<CardHolderEntity>> call(int linkId) {
    return repo.getCards(linkId);
  }
}
