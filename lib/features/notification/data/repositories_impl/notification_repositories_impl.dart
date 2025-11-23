// import 'package:drop_in/core/errors/failure.dart';
// import 'package:drop_in/core/params/notification_params.dart';
// import 'package:drop_in/features/notifications/data/datasource/notification_datasource.dart';
// import 'package:drop_in/features/notifications/domain/entities/notification_entity.dart';
// import 'package:drop_in/features/notifications/domain/entities/notification_setting_enetity.dart';
// import 'package:drop_in/features/notifications/domain/repositories/notification_repositories.dart';
// import 'package:fpdart/fpdart.dart';

// abstract class NotificationRepositoryInternal
//     implements NotificationRepository, GetNotificationRepository {}

// class NotificationRepositoryImpl implements NotificationRepositoryInternal {
//   final NotificationDatasource dataSource;

//   NotificationRepositoryImpl(this.dataSource);

//   @override
//   Future<Either<Failure, NotificationSettingsEntity>> getNotificationSettings() async {
//     final result = await dataSource.getNotificationSettings();

//     return result.fold(
//       (left) => Left(ServerFailure(errorMessage: left.errorMessage)),
//       (right) => Right(right),
//     );
//   }

//   @override
//   Future<Either<Failure, NotificationSettingsEntity>> updateNotificationToggle(
//     NotificationToogleParams params,
//   ) async {
//     final result = await dataSource.updateNotificationToggle(params);

//     return result.fold(
//       (left) => Left(ServerFailure(errorMessage: left.errorMessage)),
//       (right) => Right(right),
//     );
//   }

//   @override
//   Future<Either<Failure, NotificationListEntity>> getNotification(int page) async {
//     final notification = await dataSource.getNotification(page);

//     return notification.fold(
//       (left) => Left(ServerFailure(errorMessage: left.errorMessage)),
//       (right) => Right(right),
//     );
//   }

//   // ✅ Mark a single notification as read
//   @override
//   Future<Either<Failure, void>> markNotificationAsRead(String notificationId) async {
//     final result = await dataSource.markNotificationAsRead(notificationId);

//     return result.fold(
//       (left) => Left(ServerFailure(errorMessage: left.errorMessage)),
//       (right) => const Right(null),
//     );
//   }

//   // ✅ Mark all notifications as read
//   @override
//   Future<Either<Failure, void>> markAllNotificationsAsRead() async {
//     final result = await dataSource.markAllNotificationsAsRead();

//     return result.fold(
//       (left) => Left(ServerFailure(errorMessage: left.errorMessage)),
//       (right) => const Right(null),
//     );
//   }

//   // ✅ Get unread notification count
//   @override
//   Future<Either<Failure, int>> getUnreadNotificationCount() async {
//     final result = await dataSource.getUnreadNotificationCount();

//     return result.fold(
//       (left) => Left(ServerFailure(errorMessage: left.errorMessage)),
//       (right) => Right(right),
//     );
//   }
// }
