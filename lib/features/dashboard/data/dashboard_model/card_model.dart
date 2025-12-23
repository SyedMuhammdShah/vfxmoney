import 'package:vfxmoney/features/auth/data/auth_model/auth_user_model.dart';
import 'package:vfxmoney/features/dashboard/domain/dashboard_entity/card_entity.dart';

class CardHolderModel extends CardHolderEntity {
  const CardHolderModel({
    required super.id,
    required super.cardId,
    required super.cardHolderId,
    super.depositId,
    required super.feePaid,
    required super.cardNumber,
    required super.type,
    required super.cardHolderName,
    required super.email,
    required super.alias,
    required super.status,
    super.activatedAt,
    super.createdBy,
    required super.createdAt,
    required super.updatedAt,
    required super.balance,
    required super.user,
    required super.virtualUser,
  });

  factory CardHolderModel.fromJson(Map<String, dynamic> json) {
    return CardHolderModel(
      id: json['id'],
      cardId: json['card_id'],
      cardHolderId: json['card_holder_id'],
      depositId: json['deposit_id'],
      feePaid: json['fee_paid'],
      cardNumber: json['card_number'],
      type: json['type'],
      cardHolderName: json['card_holder_name'],
      email: json['email'],
      alias: json['alias'],
      status: json['status'],
      activatedAt: json['activated_at'] != null
          ? DateTime.tryParse(json['activated_at'].toString())
          : null,
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at'].toString()),
      updatedAt: DateTime.parse(json['updated_at'].toString()),
      balance: json['balance'],
      user: AuthUserModel.fromJson(json['user']),
      virtualUser: AuthUserModel.fromJson(json['virtual_user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'card_id': cardId,
      'card_holder_id': cardHolderId,
      'deposit_id': depositId,
      'fee_paid': feePaid,
      'card_number': cardNumber,
      'type': type,
      'card_holder_name': cardHolderName,
      'email': email,
      'alias': alias,
      'status': status,
      'activated_at': activatedAt?.toString(),
      'created_by': createdBy,
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
      'balance': balance,
      'user': (user as AuthUserModel).toJson(),
      'virtual_user': (virtualUser as AuthUserModel).toJson(),
    };
  }
}
