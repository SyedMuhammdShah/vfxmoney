import 'package:vfxmoney/core/params/dashboard_params/card_details_params.dart';
import 'package:vfxmoney/features/dashboard/data/dashboard_datasource/dashboard_datasource.dart';
import 'package:vfxmoney/features/dashboard/data/dashboard_datasource/dashboard_datasource_impl.dart';
import 'package:vfxmoney/features/dashboard/domain/dashboard_entity/card_details_entity.dart';
import 'package:vfxmoney/features/dashboard/domain/dashboard_repo/dashboard_repo.dart';

class CardRepositoryImpl implements CardRepository {
  final DashboardDatasource remote;

  CardRepositoryImpl(this.remote);

  @override
  Future<CardDetailsEntity> getCardDetails(CardDetailsParams params) {
    return remote.getCardDetails(params);
  }
}
