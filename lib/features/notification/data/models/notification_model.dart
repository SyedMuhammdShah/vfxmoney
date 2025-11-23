// import '../../domain/entities/notification_entity.dart';

// class NotificationModel extends NotificationEntity {
//   NotificationModel({
//     required super.id,
//     required super.title,
//     super.description,
//     required super.type,
//     super.chatroomID,
//     super.senderType,
//     super.senderName,
//     super.senderPicture,
//     super.badgeIdentifier,
//     super.eventID,
//     super.groupID,
//     super.userID,
//     required super.isAdmin,
//     required super.isRead,
//     required super.createdAt,
//   });

//   factory NotificationModel.fromJson(Map<String, dynamic> json) {
//     return NotificationModel(
//       id: json['_id'],
//       title: json['title'] ?? '',
//       description: json['description'],
//       type: json['type'] ?? '',
//       chatroomID: json['chatroomID']?.toString(),
//       senderType: json['senderType'],
//       senderName: json['senderName'],
//       senderPicture: json['senderPicture'],
//       badgeIdentifier: json['badgeIdentifier'],
//       eventID: json['eventID']?.toString(),
//       groupID: json['groupID']?.toString(),
//       userID: json['userID']?.toString(),
//       isAdmin: json['isAdmin'] ?? false,
//       isRead: json['isRead'] ?? false,
//       createdAt: DateTime.parse(json['createdAt']),
//     );
//   }

//   NotificationEntity toEntity() => NotificationEntity(
//     id: id,
//     title: title,
//     description: description,
//     type: type,
//     chatroomID: chatroomID,
//     senderType: senderType,
//     senderName: senderName,
//     senderPicture: senderPicture,
//     badgeIdentifier: badgeIdentifier,
//     eventID: eventID,
//     groupID: groupID,
//     userID: userID,
//     isAdmin: isAdmin,
//     isRead: isRead,
//     createdAt: createdAt,
//   );
// }


// class NotificationResponseModel extends NotificationListEntity {
//   NotificationResponseModel({
//     required super.notifications,
//     required super.pagination,
//   });

//   factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
//     final List<NotificationModel> notifications =
//         (json['data']?['notifications'] as List<dynamic>? ?? [])
//             .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
//             .toList();

//     final pagination = PaginationModel.fromJson(json['pagination']);

//     return NotificationResponseModel(
//       notifications: notifications,
//       pagination: pagination,
//     );
//   }

//   NotificationListEntity toEntity() => NotificationListEntity(
//     notifications: notifications,
//     pagination: pagination,
//   );
// }
