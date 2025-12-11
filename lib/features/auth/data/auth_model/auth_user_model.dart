import 'dart:convert';

import 'package:vfxmoney/features/auth/domain/auth_entities/auth_user_entity.dart';

class AuthUserModel extends UserEntity {
  const AuthUserModel({
    int? id,
    String? cardHolderId,
    String? physicalCardHolderId,
    String? name,
    bool? otpRequired,
    String? google2faEnabled,
    String? kycLink,
    String? email,
    String? referralCode,
    String? referredBy,
    String? referralProgram,
    String? status,
    String? role,
    String? kycVerified,
    String? emailVerification,
    String? emailVerificationCode,
    String? emailVerificationCodeExpiresAt,
    String? emailVerifiedAt,
    String? createdAt,
    String? updatedAt,
    String? token,
    String? fullPhone,
    bool? otp,
    String? ip,
    List<dynamic>? roles,
  }) : super(
         id: id,
         cardHolderId: cardHolderId,
         physicalCardHolderId: physicalCardHolderId,
         name: name,
         otpRequired: otpRequired,
         google2faEnabled: google2faEnabled,
         kycLink: kycLink,
         email: email,
         referralCode: referralCode,
         referredBy: referredBy,
         referralProgram: referralProgram,
         status: status,
         role: role,
         kycVerified: kycVerified,
         emailVerification: emailVerification,
         emailVerificationCode: emailVerificationCode,
         emailVerificationCodeExpiresAt: emailVerificationCodeExpiresAt,
         emailVerifiedAt: emailVerifiedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
         token: token,
         fullPhone: fullPhone,
         otp: otp,
         ip: ip,
         roles: roles,
       );

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    // safe helpers
    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    bool? parseBool(dynamic v) {
      if (v == null) return null;
      if (v is bool) return v;
      final s = v.toString().toLowerCase();
      if (s == '1' || s == 'true') return true;
      if (s == '0' || s == 'false') return false;
      return null;
    }

    List<dynamic>? parseList(dynamic v) {
      if (v == null) return null;
      if (v is List) return v;
      try {
        // attempt decode if stringified JSON array
        if (v is String && v.trim().isNotEmpty) {
          final decoded = v.trim();
          final parsed = decoded.startsWith('[') ? decoded : null;
          if (parsed != null) return List<dynamic>.from(jsonDecode(decoded));
        }
      } catch (_) {}
      return null;
    }

    return AuthUserModel(
      id: parseInt(json['id']),
      cardHolderId: json['card_holder_id']?.toString(),
      physicalCardHolderId: json['physical_card_holder_id']?.toString(),
      name: json['name']?.toString(),
      otpRequired: parseBool(json['otp_required']),
      google2faEnabled: json['google2fa_enabled']?.toString(),
      kycLink: json['kyc_link']?.toString(),
      email: json['email']?.toString(),
      referralCode: json['referral_code']?.toString(),
      referredBy: json['referred_by']?.toString(),
      referralProgram: json['referral_program']?.toString(),
      status: json['status']?.toString(),
      role: json['role']?.toString(),
      kycVerified: json['kyc_verified']?.toString(),
      emailVerification: json['email_verification']?.toString(),
      emailVerificationCode: json['email_verification_code']?.toString(),
      emailVerificationCodeExpiresAt: json['email_verification_code_expires_at']
          ?.toString(),
      emailVerifiedAt: json['email_verified_at']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      token: json['token']?.toString(),
      fullPhone: json['full_phone']?.toString(),
      otp: parseBool(json['otp']),
      ip: json['ip']?.toString(),
      roles:
          parseList(json['roles']) ??
          (json['roles'] is List
              ? List<dynamic>.from(json['roles'])
              : <dynamic>[]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'card_holder_id': cardHolderId,
      'physical_card_holder_id': physicalCardHolderId,
      'name': name,
      'otp_required': otpRequired,
      'google2fa_enabled': google2faEnabled,
      'kyc_link': kycLink,
      'email': email,
      'referral_code': referralCode,
      'referred_by': referredBy,
      'referral_program': referralProgram,
      'status': status,
      'role': role,
      'kyc_verified': kycVerified,
      'email_verification': emailVerification,
      'email_verification_code': emailVerificationCode,
      'email_verification_code_expires_at': emailVerificationCodeExpiresAt,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'token': token,
      'full_phone': fullPhone,
      'otp': otp,
      'ip': ip,
      'roles': roles,
    };
  }

  /// In case other code prefers explicit conversion
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      cardHolderId: cardHolderId,
      physicalCardHolderId: physicalCardHolderId,
      name: name,
      otpRequired: otpRequired,
      google2faEnabled: google2faEnabled,
      kycLink: kycLink,
      email: email,
      referralCode: referralCode,
      referredBy: referredBy,
      referralProgram: referralProgram,
      status: status,
      role: role,
      kycVerified: kycVerified,
      emailVerification: emailVerification,
      emailVerificationCode: emailVerificationCode,
      emailVerificationCodeExpiresAt: emailVerificationCodeExpiresAt,
      emailVerifiedAt: emailVerifiedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      token: token,
      fullPhone: fullPhone,
      otp: otp,
      ip: ip,
      roles: roles,
    );
  }
}
