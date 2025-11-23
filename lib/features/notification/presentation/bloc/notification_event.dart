part of 'notification_bloc.dart';

abstract class NotificationEvent {}

class LoadNotificationSettings extends NotificationEvent {}

class ToggleNotificationSetting extends NotificationEvent {
  final String key;
  final bool value;

  ToggleNotificationSetting({required this.key, required this.value});
}

class UpdateNotificationSettings extends NotificationEvent {
  final String type;
  final bool state;

  UpdateNotificationSettings({required this.type, required this.state});
}

class GetNotification extends NotificationEvent {
  final int page;
  final bool refresh;

  GetNotification({required this.page, this.refresh = false});
}

class MarkNotificationAsRead extends NotificationEvent {
  final String notificationId;

  MarkNotificationAsRead(this.notificationId);
}

class MarkAllNotificationsAsRead extends NotificationEvent {}

class GetUnreadNotificationCount extends NotificationEvent {}

class ToggleHasNew extends NotificationEvent {
  final bool toggle;

  ToggleHasNew(this.toggle);
}
