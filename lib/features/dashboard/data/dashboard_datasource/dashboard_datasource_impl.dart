import 'dart:convert';

import 'package:vfxmoney/core/params/create_card_params.dart';
import 'package:vfxmoney/core/params/dashboard_params/card_details_params.dart';
import 'package:vfxmoney/core/services/api_service.dart';
import 'package:vfxmoney/features/dashboard/data/dashboard_datasource/dashboard_datasource.dart';
import 'package:vfxmoney/features/dashboard/data/dashboard_model/card_balance_model.dart';
import 'package:vfxmoney/features/dashboard/data/dashboard_model/card_details_model.dart';
import 'package:vfxmoney/features/dashboard/data/dashboard_model/card_model.dart';

class DashboardDatasourceImpl implements DashboardDatasource {
  final ApiService apiService;

  DashboardDatasourceImpl(this.apiService);

  // Get User all Cards
  Future<List<CardHolderModel>> getCards(int linkId) async {
    final response = await apiService.post(
      '',
      payload: {'route': 'card_holder.cards_by_link_id', 'id': linkId},
      isAuthorize: true,
    );

    /// 🔥 IMPORTANT FIX
    final raw = response.data['raw'] as String;

    final jsonString = RegExp(
      r's:\d+:"(.*)";$',
      dotAll: true,
    ).firstMatch(raw)!.group(1)!;

    final decoded = jsonDecode(jsonString);

    final List list = decoded['data'];

    return list.map((e) => CardHolderModel.fromJson(e)).toList();
  }

  // Get card balance
  Future<CardBalanceModel> getCardBalance({
    required int cardId,
    required int cardHolderId,
  }) async {
    final response = await apiService.post(
      '',
      payload: {
        'route': 'strada.view_card_balance',
        'card_id': cardId,
        'card_holder_id': cardHolderId,
      },
      isAuthorize: true,
    );

    final raw = response.data['raw'] as String;
    final jsonString = RegExp(
      r's:\d+:"(.*)";$',
      dotAll: true,
    ).firstMatch(raw)!.group(1)!;

    final decoded = jsonDecode(jsonString);
    return CardBalanceModel.fromJson(decoded['data']);
  }

  // Get Card Details
  Future<CardDetailsModel> getCardDetails(int cardId) async {
    final response = await apiService.post(
      '',
      payload: {'route': 'strada.card_details', 'card_id': cardId},
      isAuthorize: true,
    );

    final raw = response.data['raw'] as String;
    final jsonString = RegExp(
      r's:\d+:"(.*)";$',
      dotAll: true,
    ).firstMatch(raw)!.group(1)!;

    final decoded = jsonDecode(jsonString);

    return CardDetailsModel.fromJson(decoded['data']);
  }

  // Create New Card
  Future<void> createCard(CreateCardParams params) async {
    final response = await apiService.post(
      '',
      payload: params.toJson(),
      isAuthorize: true,
    );

    final raw = response.data['raw'] as String;
    final jsonString = RegExp(
      r's:\d+:"(.*)";$',
      dotAll: true,
    ).firstMatch(raw)!.group(1)!;

    final decoded = jsonDecode(jsonString);

    if (decoded['success'] != true) {
      throw Exception(decoded['message'] ?? 'Failed to create card');
    }
  }
}
