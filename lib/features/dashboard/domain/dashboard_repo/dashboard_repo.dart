
import 'package:vfxmoney/features/dashboard/data/dashboard_model/card_model.dart';

abstract class DashboardRepo {
  Future<List<CardHolderModel>> getCards(int linkId);
}
