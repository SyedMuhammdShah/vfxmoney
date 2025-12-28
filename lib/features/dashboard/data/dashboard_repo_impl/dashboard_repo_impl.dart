import 'package:vfxmoney/core/params/create_card_params.dart';
import 'package:vfxmoney/core/params/dashboard_params/card_details_params.dart';
import 'package:vfxmoney/features/dashboard/data/dashboard_datasource/dashboard_datasource.dart';
import 'package:vfxmoney/features/dashboard/data/dashboard_datasource/dashboard_datasource_impl.dart';
import 'package:vfxmoney/features/dashboard/data/dashboard_model/card_model.dart';
import 'package:vfxmoney/features/dashboard/domain/dashboard_entity/card_balance_entity.dart';
import 'package:vfxmoney/features/dashboard/domain/dashboard_entity/card_details_entity.dart';
import 'package:vfxmoney/features/dashboard/domain/dashboard_repo/dashboard_repo.dart';

class DashboardRepoImpl implements DashboardRepo {
  final DashboardDatasource remote;

  DashboardRepoImpl(this.remote);

  @override
  Future<CardDetailsEntity> getCardDetails(int cardId) {
    return remote.getCardDetails(cardId);
  }

  @override
  Future<List<CardHolderModel>> getCards(int linkId) {
    return remote.getCards(linkId);
  }

  @override
  Future<CardBalanceEntity> getCardBalance(int cardId, int cardHolderId) {
    return remote.getCardBalance(cardId: cardId, cardHolderId: cardHolderId);
  }

  @override
  Future<void> createCard(CreateCardParams params) {
    return remote.createCard(params);
  }
}
