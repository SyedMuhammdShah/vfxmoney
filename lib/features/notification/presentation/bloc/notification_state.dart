// part of 'notification_bloc.dart';

// class NotificationState {
//   final NotificationSettingsEntity? settings;
//   final Result result;
//   final List<NotificationEntity> notifications;
//   final PaginationEntity pagination;
//   final int unreadCount;
//   final bool hasNew;

//   NotificationState({
//     required this.settings,
//     required this.result,
//     this.notifications = const [],
//     required this.pagination,
//     required this.unreadCount,
//     required this.hasNew,
//   });

//   factory NotificationState.initial() {
//     return NotificationState(
//       settings: null,
//       result: Result.idle(),
//       notifications: [],
//       pagination: PaginationEntity(
//         itemsPerPage: 0,
//         currentPage: 0,
//         totalItems: 0,
//         totalPages: 0,
//       ),
//       unreadCount: 0,
//       hasNew: false,
//     );
//   }

//   NotificationState copyWith({
//     NotificationSettingsEntity? settings,
//     Result? result,
//     List<NotificationEntity>? notifications,
//     PaginationEntity? pagination,
//     int? unreadCount,
//     bool? hasNew,
//   }) {
//     return NotificationState(
//       settings: settings ?? this.settings,
//       result: result ?? this.result,
//       notifications: notifications ?? this.notifications,
//       pagination: pagination ?? this.pagination,
//       unreadCount: unreadCount ?? this.unreadCount,
//       hasNew: hasNew ?? this.hasNew,
//     );
//   }
// }
