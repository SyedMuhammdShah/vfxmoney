import 'package:vfxmoney/core/params/dashboard_params/card_details_params.dart';
import 'package:vfxmoney/features/dashboard/domain/dashboard_entity/card_details_entity.dart';

abstract class CardRepository {
  Future<CardDetailsEntity> getCardDetails(CardDetailsParams params);
}
