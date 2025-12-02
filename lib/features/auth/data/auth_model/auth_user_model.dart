import 'package:vfxmoney/features/auth/domain/auth_entities/auth_user_entity.dart';

class AuthUserModel extends UserEntity {
  const AuthUserModel({
    int? id,
    String? cardHolderId,
    String? name,
    bool? otpRequired,
    String? email,
    String? status,
    String? token,
    String? createdAt,
    String? updatedAt,
  }) : super(
         id: id,
         cardHolderId: cardHolderId,
         name: name,
         otpRequired: otpRequired,
         email: email,
         status: status,
         token: token,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'] is int
          ? json['id'] as int
          : (json['id'] != null ? int.tryParse(json['id'].toString()) : null),
      cardHolderId: json['card_holder_id']?.toString(),
      name: json['name']?.toString(),
      otpRequired: json['otp_required'] is bool
          ? json['otp_required'] as bool
          : (json['otp_required'] != null
                ? (json['otp_required'].toString() == '1' ||
                      json['otp_required'].toString().toLowerCase() == 'true')
                : false),
      email: json['email']?.toString(),
      status: json['status']?.toString(),
      token: json['token']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'card_holder_id': cardHolderId,
      'name': name,
      'otp_required': otpRequired,
      'email': email,
      'status': status,
      'token': token,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Convert back to domain entity (redundant as model already extends entity)
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      cardHolderId: cardHolderId,
      name: name,
      otpRequired: otpRequired,
      email: email,
      status: status,
      token: token,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
