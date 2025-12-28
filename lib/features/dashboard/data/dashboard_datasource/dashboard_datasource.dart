import 'package:vfxmoney/core/params/create_card_params.dart';
import 'package:vfxmoney/core/params/dashboard_params/card_details_params.dart';
import 'package:vfxmoney/features/dashboard/data/dashboard_model/card_balance_model.dart';
import 'package:vfxmoney/features/dashboard/data/dashboard_model/card_details_model.dart';
import 'package:vfxmoney/features/dashboard/data/dashboard_model/card_model.dart';

abstract class DashboardDatasource {
  Future<CardDetailsModel> getCardDetails(int cardId);
  Future<List<CardHolderModel>> getCards(int linkId);
  Future<CardBalanceModel> getCardBalance({
    required int cardId,
    required int cardHolderId,
  });
  Future<void> createCard(CreateCardParams params);
}
