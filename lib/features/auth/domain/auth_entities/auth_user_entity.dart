import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int? id;
  final String? cardHolderId;
  final String? physicalCardHolderId;
  final String? name;
  final bool? otpRequired;
  final String? google2faEnabled;
  final String? kycLink;
  final String? email;
  final String? referralCode;
  final String? referredBy;
  final String? referralProgram;
  final String? status;
  final String? role;
  final String? kycVerified;
  final String? emailVerification;
  final String? emailVerificationCode;
  final String? emailVerificationCodeExpiresAt;
  final String? emailVerifiedAt;
  final String? createdAt;
  final String? updatedAt;
  final String? token;
  final String? fullPhone;
  final bool? otp;
  final String? ip;
  final List<dynamic>? roles; // keep dynamic to accept mixed types

  const UserEntity({
    this.id,
    this.cardHolderId,
    this.physicalCardHolderId,
    this.name,
    this.otpRequired,
    this.google2faEnabled,
    this.kycLink,
    this.email,
    this.referralCode,
    this.referredBy,
    this.referralProgram,
    this.status,
    this.role,
    this.kycVerified,
    this.emailVerification,
    this.emailVerificationCode,
    this.emailVerificationCodeExpiresAt,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.token,
    this.fullPhone,
    this.otp,
    this.ip,
    this.roles,
  });

  @override
  List<Object?> get props => [
        id,
        cardHolderId,
        physicalCardHolderId,
        name,
        otpRequired,
        google2faEnabled,
        kycLink,
        email,
        referralCode,
        referredBy,
        referralProgram,
        status,
        role,
        kycVerified,
        emailVerification,
        emailVerificationCode,
        emailVerificationCodeExpiresAt,
        emailVerifiedAt,
        createdAt,
        updatedAt,
        token,
        fullPhone,
        otp,
        ip,
        roles,
      ];
}
