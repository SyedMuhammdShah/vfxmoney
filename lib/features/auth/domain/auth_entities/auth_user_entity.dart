import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int? id;
  final String? cardHolderId;
  final String? name;
  final bool? otpRequired;
  final String? email;
  final String? status;
  final String? token;
  final String? createdAt;
  final String? updatedAt;

  const UserEntity({
    this.id,
    this.cardHolderId,
    this.name,
    this.otpRequired,
    this.email,
    this.status,
    this.token,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        cardHolderId,
        name,
        otpRequired,
        email,
        status,
        token,
        createdAt,
        updatedAt,
      ];
}
