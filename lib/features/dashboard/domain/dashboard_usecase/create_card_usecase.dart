import 'package:vfxmoney/core/params/create_card_params.dart';
import 'package:vfxmoney/core/services/storage_service.dart';
import 'package:vfxmoney/features/dashboard/domain/dashboard_repo/dashboard_repo.dart';

class CreateCardUseCase {
  final DashboardRepo repo;
  final StorageService storage;

  CreateCardUseCase(this.repo, this.storage);

  Future<void> call({required String alias, required String cardType}) async {
    final user = storage.getUser;

    if (user == null) {
      throw Exception('User not found');
    }

    // ...existing code...
    final cardHolderId = int.tryParse(user.cardHolderId ?? '');
    if (cardHolderId == null) {
      throw Exception('Invalid or missing cardHolderId');
    }

    if (user.email == null || user.email!.isEmpty) {
      throw Exception('Invalid or missing email');
    }

    final params = CreateCardParams(
      email: user.email!,
      alias: alias,
      cardHolderId: cardHolderId,
      cardType: cardType,
    );

    await repo.createCard(params);
  }
}
