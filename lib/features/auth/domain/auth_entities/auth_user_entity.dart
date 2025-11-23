import 'package:equatable/equatable.dart';

class AuthUserEntity extends Equatable {
  final String token;
  final UserEntity? user;

  const AuthUserEntity({required this.token, this.user});

  @override
  List<Object?> get props => [token, user];
}

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profilePicture;
  final String? uid;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool isAddress;
  final String identityStatus;
  final bool isProfileCompleted;
  final String stripeProfileStatus;
  final bool isDeactivatedByAdmin;
  final bool isDeleted;
  final String? signUpRecord;
  final String? stripeAccountId;
  final String? stripeCustomerId;
  final String? stripeBankId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profilePicture,
    this.uid,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.isAddress,
    required this.identityStatus,
    required this.isProfileCompleted,
    required this.stripeProfileStatus,
    required this.isDeactivatedByAdmin,
    required this.isDeleted,
    this.signUpRecord,
    this.stripeAccountId,
    this.stripeCustomerId,
    this.stripeBankId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    profilePicture,
    uid,
    isEmailVerified,
    isPhoneVerified,
    isAddress,
    identityStatus,
    isProfileCompleted,
    stripeProfileStatus,
    isDeactivatedByAdmin,
    isDeleted,
    signUpRecord,
    stripeAccountId,
    stripeCustomerId,
    stripeBankId,
    createdAt,
    updatedAt,
  ];
}
