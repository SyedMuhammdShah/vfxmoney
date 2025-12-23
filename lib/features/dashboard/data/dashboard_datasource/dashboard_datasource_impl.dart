import 'package:vfxmoney/core/params/dashboard_params/card_details_params.dart';
import 'package:vfxmoney/core/services/api_service.dart';
import 'package:vfxmoney/features/dashboard/data/dashboard_datasource/dashboard_datasource.dart';
import 'package:vfxmoney/features/dashboard/data/dashboard_model/card_details_model.dart';
import 'package:vfxmoney/features/dashboard/data/dashboard_model/card_model.dart';

class DashboardDatasourceImpl implements DashboardDatasource {
  final ApiService apiService;

  DashboardDatasourceImpl(this.apiService);

  @override
  Future<List<CardHolderModel>> getCards(int linkId) async {
    final response = await apiService.post(
      '',
      payload: {'route': 'card_holder.cards_by_link_id', 'id': linkId},
      isAuthorize: true,
    );

    final List data = response.data['data'];
    return data.map((e) => CardHolderModel.fromJson(e)).toList();
  }
}
