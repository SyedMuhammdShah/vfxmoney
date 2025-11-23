// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class RegisterProfileParams extends Equatable {
  final File profilePicture;
  final String email;
  final String phone;
  final String name;
  final String idToken;
  final String role;

  const RegisterProfileParams({
    required this.email,
    required this.phone,
    required this.name,
    required this.profilePicture,
    required this.idToken,
    required this.role,
  });

  FormData toFormData() {
    return FormData.fromMap({
      "email": email,
      "phone": phone,
      "profilePicture": MultipartFile.fromFileSync(
        profilePicture.path,
        filename: profilePicture.path.split('/').last,
      ),
      "idToken": idToken,
      "role": role,
      "name": name,
    });
  }

  @override
  List<Object?> get props => [
    email,
    name,
    phone,
    profilePicture,
    idToken,
    role,
  ];
}

class UpdateFcmParams {
  final String fcmToken;

  const UpdateFcmParams({required this.fcmToken});

  Map<String, dynamic> toJson() {
    return {'fcmToken': fcmToken};
  }
}

class SocialSignInParam {
  final String idToken;
  final String fcmToken;

  SocialSignInParam({required this.idToken, required this.fcmToken});

  Map<String, String> toJson() {
    return {'idToken': idToken, 'fcmToken': fcmToken, 'role': 'user'};
  }
}

class SocialRegisterParam {
  final String phone;
  final String name;
  final File profilePicture;

  SocialRegisterParam({
    required this.phone,
    required this.name,
    required this.profilePicture,
  });

  FormData toFormData() {
    return FormData.fromMap({
      "phone": phone,
      "profilePicture": MultipartFile.fromFileSync(
        profilePicture.path,
        filename: profilePicture.path.split('/').last,
      ),
      "name": name,
    });
  }
}

class SocialOTPParam {
  final String otp;

  SocialOTPParam({required this.otp});

  Map<String, String> toJson() {
    return {'otp': otp};
  }
}

class UpdateProfileParams extends Equatable {
  final String name;
  final File? profileImage;

  const UpdateProfileParams({required this.name, this.profileImage});

  /// Convert to form-data for multipart upload
  FormData toFormData() {
    final formData = FormData.fromMap({
      'name': name,

      if (profileImage != null)
        'profilePicture': MultipartFile.fromFileSync(profileImage!.path),
    });
    return formData;
  }

  @override
  List<Object?> get props => [name];
}
