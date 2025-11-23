// import 'package:drop_in/core/entity/pagination_entity.dart';

// class NotificationEntity {
//   final String id;
//   final String title;
//   final String? description;
//   final String type;
//   final String? chatroomID;
//   final String? senderType;
//   final String? senderName;
//   final String? senderPicture;
//   final String? eventID;
//   final String? groupID;
//   final String? userID;
//   final String? badgeID;
//   final String? badgeIdentifier;
//   final bool isAdmin;
//   final bool isRead;
//   final DateTime createdAt;

//   NotificationEntity({
//     required this.id,
//     required this.title,
//     this.description,
//     required this.type,
//     this.chatroomID,
//     this.senderType,
//     this.senderName,
//     this.senderPicture,
//     this.eventID,
//     this.groupID,
//     this.userID,
//     this.badgeID,
//     this.badgeIdentifier,
//     required this.isAdmin,
//     required this.isRead,
//     required this.createdAt,
//   });
//   NotificationEntity copyWith({
//     String? id,
//     String? title,
//     String? description,
//     String? type,
//     String? chatroomID,
//     String? senderType,
//     String? senderName,
//     String? senderPicture,
//     String? eventID,
//     String? groupID,
//     String? userID,
//     String? badgeID,
//     String? badgeIdentifier,
//     bool? isAdmin,
//     bool? isRead,
//     DateTime? createdAt,
//   }) {
//     return NotificationEntity(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       type: type ?? this.type,
//       chatroomID: chatroomID ?? this.chatroomID,
//       senderType: senderType ?? this.senderType,
//       senderName: senderName ?? this.senderName,
//       senderPicture: senderPicture ?? this.senderPicture,
//       eventID: eventID ?? this.eventID,
//       groupID: groupID ?? this.groupID,
//       userID: userID ?? this.userID,
//       badgeID: badgeID ?? this.badgeID,
//       badgeIdentifier: badgeIdentifier ?? this.badgeIdentifier,
//       isAdmin: isAdmin ?? this.isAdmin,
//       isRead: isRead ?? this.isRead,
//       createdAt: createdAt ?? this.createdAt,
//     );
//   }
// }

// class NotificationListEntity {
//   final List<NotificationEntity> notifications;
//   final PaginationEntity pagination;

//   NotificationListEntity({
//     required this.notifications,
//     required this.pagination,
//   });
// }
