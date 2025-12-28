import 'package:vfxmoney/core/params/create_card_params.dart';
import 'package:vfxmoney/features/dashboard/data/dashboard_model/card_model.dart';
import 'package:vfxmoney/features/dashboard/domain/dashboard_entity/card_balance_entity.dart';
import 'package:vfxmoney/features/dashboard/domain/dashboard_entity/card_details_entity.dart';

abstract class DashboardRepo {
  Future<CardDetailsEntity> getCardDetails(int cardId);
  Future<List<CardHolderModel>> getCards(int linkId);
  Future<CardBalanceEntity> getCardBalance(int cardId, int cardHolderId);
  Future<void> createCard(CreateCardParams params);
}
