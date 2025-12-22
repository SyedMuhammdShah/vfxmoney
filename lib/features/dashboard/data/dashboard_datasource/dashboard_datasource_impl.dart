import 'package:vfxmoney/core/params/dashboard_params/card_details_params.dart';
import 'package:vfxmoney/core/services/api_service.dart';
import 'package:vfxmoney/features/dashboard/data/dashboard_datasource/dashboard_datasource.dart';
import 'package:vfxmoney/features/dashboard/data/dashboard_model/CardDetailsModel.dart';

class DashboardDatasourceImpl implements DashboardDatasource {
  final ApiService apiService;

  DashboardDatasourceImpl(this.apiService);

  @override
  Future<CardDetailsModel> getCardDetails(CardDetailsParams params) async {
    final response = await apiService.post(
      '',
      payload: params.toJson(),
      isAuthorize: true, // 🔐 token auto injected
      encryptPayload: false,
    );

    final data = response.data['data'] as Map<String, dynamic>;
    return CardDetailsModel.fromJson(data);
  }
}
