// import 'package:drop_in/core/errors/failure.dart';
// import 'package:drop_in/core/params/notification_params.dart';
// import 'package:drop_in/features/notifications/domain/entities/notification_entity.dart';
// import 'package:drop_in/features/notifications/domain/entities/notification_setting_enetity.dart';
// import 'package:drop_in/features/notifications/domain/repositories/notification_repositories.dart';
// import 'package:fpdart/fpdart.dart';

// class NotificationToogleUsecase {
//   final NotificationRepository repository;
//   NotificationToogleUsecase(this.repository);

//   Future<Either<Failure, NotificationSettingsEntity>> call(
//     NotificationToogleParams params,
//   ) async {
//     return await repository.updateNotificationToggle(params);
//   }
// }

// class GetNotificationSettingsUseCase {
//   final NotificationRepository repository;

//   GetNotificationSettingsUseCase(this.repository);

//   Future<Either<Failure, NotificationSettingsEntity>> call() {
//     return repository.getNotificationSettings();
//   }
// }

// class GetNotificationsUseCase {
//   final GetNotificationRepository repository;

//   GetNotificationsUseCase(this.repository);

//   Future<Either<Failure, NotificationListEntity>> call(int page) {
//     return repository.getNotification(page);
//   }
// }

// class MarkNotificationAsReadUseCase {
//   final NotificationRepository repository;

//   MarkNotificationAsReadUseCase(this.repository);

//   Future<Either<Failure, void>> call(String notificationId) {
//     return repository.markNotificationAsRead(notificationId);
//   }
// }

// class MarkAllNotificationsAsReadUseCase {
//   final NotificationRepository repository;

//   MarkAllNotificationsAsReadUseCase(this.repository);

//   Future<Either<Failure, void>> call() {
//     return repository.markAllNotificationsAsRead();
//   }
// }

// class GetUnreadNotificationCountUseCase {
//   final NotificationRepository repository;

//   GetUnreadNotificationCountUseCase(this.repository);

//   Future<Either<Failure, int>> call() {
//     return repository.getUnreadNotificationCount();
//   }
// }
// 