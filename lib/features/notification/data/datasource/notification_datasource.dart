// import 'package:drop_in/core/constants/api_endpoints.dart';
// import 'package:drop_in/core/errors/exceptions.dart';
// import 'package:drop_in/core/errors/failure.dart';
// import 'package:drop_in/core/params/notification_params.dart';
// import 'package:drop_in/features/auth/data/models/user_model.dart';
// import 'package:drop_in/features/notifications/data/model/notification_reponse_model.dart';
// import 'package:drop_in/features/notifications/domain/entities/notification_entity.dart';
// import 'package:drop_in/features/notifications/domain/entities/notification_setting_enetity.dart';
// import 'package:fpdart/fpdart.dart';

// import '../../../../core/services/api_service.dart';
// import '../../../../core/services/service_locator.dart';
// import '../../../../core/services/storage_service.dart';

// abstract class NotificationDatasource {
//   Future<Either<Failure, NotificationSettingsEntity>> getNotificationSettings();
//   Future<Either<Failure, NotificationListEntity>> getNotification(int page);

//   Future<Either<Failure, NotificationSettingsEntity>> updateNotificationToggle(
//     NotificationToogleParams params,
//   );
//   Future<Either<Failure, void>> markNotificationAsRead(String id);
//   Future<Either<Failure, void>> markAllNotificationsAsRead();
//   Future<Either<Failure, int>> getUnreadNotificationCount();
// }

// class NotificationDatasourceImpl extends NotificationDatasource {
//   final ApiService apiService = locator<ApiService>();
//   final StorageService storageService = locator<StorageService>();

//   @override
//   Future<Either<Failure, NotificationSettingsEntity>>
//   getNotificationSettings() async {
//     try {
//       final storedUser = storageService.getUser;
//       if (storedUser is UserModel && storedUser.notificationSettings != null) {
//         return Right(storedUser.notificationSettings!);
//       } else {
//         return Left(
//           ServerFailure(errorMessage: 'No notification settings found'),
//         );
//       }
//     } on Exception catch (_) {
//       return Left(
//         ServerFailure(errorMessage: 'Failed to get notification settings'),
//       );
//     }
//   }

//   @override
//   Future<Either<Failure, NotificationSettingsEntity>> updateNotificationToggle(
//     NotificationToogleParams params,
//   ) async {
//     try {
//       final res = await apiService.post(
//         ApiEndpoints.notificationToogle,
//         isAuthorize: true,
//         queryParams: {'type': params.type, 'state': params.state},
//       );

//       final settingsJson =
//           res.data['data']['updatedNotificationSettings']['settings'];
//       final updatedSettings = NotificationSettingsModel.fromJson(settingsJson);

//       final storedUser = storageService.getUser;
//       if (storedUser is UserModel) {
//         final userJson = storedUser.toJson();
//         userJson['notificationSettings'] = updatedSettings.toJson();
//         await storageService.setUser(userJson);
//       }

//       return Right(updatedSettings);
//     } on ServerException catch (e) {
//       return Left(
//         ServerFailure(errorMessage: e.message ?? 'Something went wrong'),
//       );
//     }
//   }

//   @override
//   Future<Either<Failure, NotificationListEntity>> getNotification(
//     int page,
//   ) async {
//     try {
//       final response = await apiService.get(
//         ApiEndpoints.getNotification,
//         isAuthorize: true,
//         queryParameters: {'page': page},
//       );
//       if (response.statusCode == 200) {
//         final getNotification = NotificationResponseModel.fromJson(
//           response.data,
//         );
//         return Right(getNotification);
//       } else {
//         final message = response.data['message'] ?? 'Unknown error';
//         return Left(ServerFailure(errorMessage: message));
//       }
//     } catch (e) {
//       return Left(ServerFailure(errorMessage: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> markNotificationAsRead(String id) async {
//     try {
//       final response = await apiService.post(
//         ApiEndpoints.markNotificationAsRead,
//         queryParams: {'notificationID': id},
//         isAuthorize: true,
//       );

//       if (response.statusCode == 200) {
//         return const Right(null);
//       } else {
//         return Left(
//           ServerFailure(
//             errorMessage: response.data['message'] ?? 'Failed to mark as read',
//           ),
//         );
//       }
//     } catch (e) {
//       return Left(ServerFailure(errorMessage: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> markAllNotificationsAsRead() async {
//     try {
//       final response = await apiService.post(
//         ApiEndpoints.markAllNotificationsAsRead,
//         isAuthorize: true,
//       );

//       if (response.statusCode == 200) {
//         return const Right(null);
//       } else {
//         return Left(
//           ServerFailure(
//             errorMessage:
//                 response.data['message'] ?? 'Failed to mark all as read',
//           ),
//         );
//       }
//     } catch (e) {
//       return Left(ServerFailure(errorMessage: e.toString()));
//     }
//   }

//   // ✅ 3. Get unread notification count
//   @override
//   Future<Either<Failure, int>> getUnreadNotificationCount() async {
//     try {
//       final response = await apiService.get(
//         ApiEndpoints.getUnreadNotificationCount,
//         isAuthorize: true,
//       );

//       if (response.statusCode == 200) {
//         final count = response.data['data']['unreadCount'];
//         return Right(count);
//       } else {
//         return Left(
//           ServerFailure(
//             errorMessage:
//                 response.data['message'] ?? 'Failed to get unread count',
//           ),
//         );
//       }
//     } catch (e) {
//       return Left(ServerFailure(errorMessage: e.toString()));
//     }
//   }
// }
