import 'package:vfxmoney/core/params/dashboard_params/card_details_params.dart';
import 'package:vfxmoney/features/dashboard/data/dashboard_model/CardDetailsModel.dart';

abstract class DashboardDatasource {
  Future<CardDetailsModel> getCardDetails(CardDetailsParams params);
}
