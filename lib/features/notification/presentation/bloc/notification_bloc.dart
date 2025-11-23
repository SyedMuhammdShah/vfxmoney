// import 'package:drop_in/core/entity/pagination_entity.dart';
// import 'package:drop_in/core/params/notification_params.dart';
// import 'package:drop_in/features/notifications/domain/entities/notification_entity.dart';
// import 'package:drop_in/features/notifications/domain/entities/notification_setting_enetity.dart';
// import 'package:drop_in/features/notifications/domain/usecase/notification_usecase.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../../core/constants/enums.dart';
// import '../../../../../core/services/service_locator.dart';

// part 'notification_event.dart';
// part 'notification_state.dart';

// class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
//   NotificationBloc() : super(NotificationState.initial()) {
//     on<LoadNotificationSettings>(_onLoad);
//     on<ToggleNotificationSetting>(_onToggle);
//     on<UpdateNotificationSettings>(_onUpdate);
//     on<GetNotification>(_getNotification);
//     on<MarkNotificationAsRead>(_onMarkSingleRead);
//     on<MarkAllNotificationsAsRead>(_onMarkAllRead);
//     on<GetUnreadNotificationCount>(_onGetUnreadCount);
//     on<ToggleHasNew>(_onToggleHasNew);
//   }

//   Future<void> _onLoad(
//     LoadNotificationSettings event,
//     Emitter<NotificationState> emit,
//   ) async {
//     emit(state.copyWith(result: Result.loading(event)));

//     final result = await locator<GetNotificationSettingsUseCase>()();

//     result.fold(
//       (failure) => emit(
//         state.copyWith(result: Result.error(failure.errorMessage, event)),
//       ),
//       (settings) => emit(
//         state.copyWith(
//           result: Result.successful("Loaded", event),
//           settings: settings,
//         ),
//       ),
//     );
//   }

//   void _onToggleHasNew(ToggleHasNew event, Emitter<NotificationState> emit) {
//     emit(state.copyWith(hasNew: event.toggle));
//   }

//   Future<void> _onToggle(
//     ToggleNotificationSetting event,
//     Emitter<NotificationState> emit,
//   ) async {
//     emit(state.copyWith(result: Result.loading(event)));

//     final result = await locator<NotificationToogleUsecase>()(
//       NotificationToogleParams(type: event.key, state: event.value),
//     );

//     result.fold(
//       (failure) {
//         emit(state.copyWith(result: Result.error(failure.errorMessage, event)));
//       },
//       (updatedSettings) {
//         emit(
//           state.copyWith(
//             settings: updatedSettings,
//             result: Result.successful("Updated", event),
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _onUpdate(
//     UpdateNotificationSettings event,
//     Emitter<NotificationState> emit,
//   ) async {
//     emit(state.copyWith(result: Result.loading(event)));

//     final result = await locator<NotificationToogleUsecase>()(
//       NotificationToogleParams(type: event.type, state: event.state),
//     );

//     result.fold(
//       (failure) => emit(
//         state.copyWith(result: Result.error(failure.errorMessage, event)),
//       ),
//       (_) => emit(state.copyWith(result: Result.successful("Updated", event))),
//     );
//   }

//   void _getNotification(
//     GetNotification event,
//     Emitter<NotificationState> emit,
//   ) async {
//     if (state.result.status == ResultStatus.loading &&
//         state.result.event is GetNotification) {
//       return;
//     }

//     final initialPagination = PaginationEntity(
//       itemsPerPage: 0,
//       currentPage: 0,
//       totalItems: 0,
//       totalPages: 0,
//     );

//     emit(
//       state.copyWith(
//         result: Result.loading(event),
//         notifications: event.refresh ? [] : null,
//         pagination: event.refresh ? initialPagination : null,
//       ),
//     );

//     final currentPage = state.pagination.currentPage;
//     final page = event.refresh ? 1 : currentPage + 1;

//     final response = await locator<GetNotificationsUseCase>().call(
//       page.toInt(),
//     );

//     response.fold(
//       (failure) {
//         emit(state.copyWith(result: Result.error(failure.errorMessage, event)));
//       },
//       (entity) {
//         final updatedEntries = [
//           if (!event.refresh) ...state.notifications,
//           ...entity.notifications,
//         ];

//         emit(
//           state.copyWith(
//             result: Result.successful("Fetched Notification", event),
//             notifications: updatedEntries,
//             pagination: entity.pagination,
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _onMarkSingleRead(
//     MarkNotificationAsRead event,
//     Emitter<NotificationState> emit,
//   ) async {
//     emit(state.copyWith(result: Result.loading(event)));

//     final result = await locator<MarkNotificationAsReadUseCase>()(
//       event.notificationId,
//     );

//     result.fold(
//       (failure) => emit(
//         state.copyWith(result: Result.error(failure.errorMessage, event)),
//       ),
//       (_) {
//         final updatedList =
//             state.notifications.map((n) {
//               if (n.id == event.notificationId) {
//                 return n.copyWith(isRead: true);
//               }
//               return n;
//             }).toList();

//         emit(
//           state.copyWith(
//             notifications: updatedList,
//             result: Result.successful("Marked as read", event),
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _onMarkAllRead(
//     MarkAllNotificationsAsRead event,
//     Emitter<NotificationState> emit,
//   ) async {
//     emit(state.copyWith(result: Result.loading(event)));

//     final result = await locator<MarkAllNotificationsAsReadUseCase>()();

//     result.fold(
//       (failure) => emit(
//         state.copyWith(result: Result.error(failure.errorMessage, event)),
//       ),
//       (_) {
//         final updatedList =
//             state.notifications.map((n) => n.copyWith(isRead: true)).toList();

//         emit(
//           state.copyWith(
//             notifications: updatedList,
//             result: Result.successful("All marked as read", event),
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _onGetUnreadCount(
//     GetUnreadNotificationCount event,
//     Emitter<NotificationState> emit,
//   ) async {
//     final result = await locator<GetUnreadNotificationCountUseCase>()();

//     result.fold(
//       (failure) => emit(
//         state.copyWith(result: Result.error(failure.errorMessage, event)),
//       ),
//       (count) {
//         if (count > 0) {
//           add(ToggleHasNew(true));
//         }
//         emit(state.copyWith(unreadCount: count));
//       },
//     );
//   }
// }
