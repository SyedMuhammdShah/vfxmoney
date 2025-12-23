import 'package:vfxmoney/core/params/dashboard_params/card_details_params.dart';
import 'package:vfxmoney/features/dashboard/data/dashboard_model/card_details_model.dart';
import 'package:vfxmoney/features/dashboard/data/dashboard_model/card_model.dart';

abstract class DashboardDatasource {
  //Future<CardDetailsModel> getCardDetails(CardDetailsParams params);
  Future<List<CardHolderModel>> getCards(int linkId);
}
