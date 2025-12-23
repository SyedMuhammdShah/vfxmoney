import 'package:vfxmoney/features/auth/domain/auth_entities/auth_user_entity.dart';

class CardHolderEntity {
  final int id;
  final String cardId;
  final String cardHolderId;
  final String? depositId;
  final bool feePaid;
  final String cardNumber;
  final String type;
  final String cardHolderName;
  final String email;
  final String alias;
  final String status;
  final DateTime? activatedAt;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String balance;
  final UserEntity user;
  final UserEntity virtualUser;

  const CardHolderEntity({
    required this.id,
    required this.cardId,
    required this.cardHolderId,
    this.depositId,
    required this.feePaid,
    required this.cardNumber,
    required this.type,
    required this.cardHolderName,
    required this.email,
    required this.alias,
    required this.status,
    this.activatedAt,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.balance,
    required this.user,
    required this.virtualUser,
  });
}
