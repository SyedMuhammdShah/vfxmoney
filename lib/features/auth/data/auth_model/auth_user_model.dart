import 'package:vfxmoney/features/auth/domain/auth_entities/auth_user_entity.dart';

class AuthUserModel extends AuthUserEntity {
  const AuthUserModel({required super.token, super.user});

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      token: json['token'] ?? '',
      user: json['user'] != null
          ? (json['user'] is Map<String, dynamic>
                ? UserModel.fromJson(json['user'])
                : json['user'] as UserModel)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user != null ? (user as UserModel).toJson() : null,
    };
  }
}

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    super.profilePicture,
    super.uid,
    required super.isEmailVerified,
    required super.isPhoneVerified,
    required super.isAddress,
    required super.identityStatus,
    required super.isProfileCompleted,
    required super.stripeProfileStatus,
    required super.isDeactivatedByAdmin,
    required super.isDeleted,
    super.signUpRecord,
    super.stripeAccountId,
    super.stripeCustomerId,
    super.stripeBankId,
    super.createdAt,
    super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profilePicture: json['profilePicture'],
      uid: json['uid'],
      isEmailVerified: json['isEmailVerified'] ?? false,
      isPhoneVerified: json['isPhoneVerified'] ?? false,
      isAddress: json['isAddress'] ?? false,
      identityStatus: json['identityStatus'] ?? '',
      isProfileCompleted: json['isProfileCompleted'] ?? false,
      stripeProfileStatus: json['stripeProfileStatus'] ?? '',
      isDeactivatedByAdmin: json['isDeactivatedByAdmin'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      signUpRecord: json['signUpRecord'],
      stripeAccountId: json['stripeAccountId'],
      stripeCustomerId: json['stripeCustomerId'],
      stripeBankId: json['stripeBankId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profilePicture': profilePicture,
      'uid': uid,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'isAddress': isAddress,

      'identityStatus': identityStatus,
      'isProfileCompleted': isProfileCompleted,
      'stripeProfileStatus': stripeProfileStatus,
      'isDeactivatedByAdmin': isDeactivatedByAdmin,
      'isDeleted': isDeleted,
      'signUpRecord': signUpRecord,
      'stripeAccountId': stripeAccountId,
      'stripeCustomerId': stripeCustomerId,
      'stripeBankId': stripeBankId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      profilePicture: entity.profilePicture,
      uid: entity.uid,
      isEmailVerified: entity.isEmailVerified,
      isPhoneVerified: entity.isPhoneVerified,
      isAddress: entity.isAddress,
      identityStatus: entity.identityStatus,
      isProfileCompleted: entity.isProfileCompleted,
      stripeProfileStatus: entity.stripeProfileStatus,
      isDeactivatedByAdmin: entity.isDeactivatedByAdmin,
      isDeleted: entity.isDeleted,
      signUpRecord: entity.signUpRecord,
      stripeAccountId: entity.stripeAccountId,
      stripeCustomerId: entity.stripeCustomerId,
      stripeBankId: entity.stripeBankId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
