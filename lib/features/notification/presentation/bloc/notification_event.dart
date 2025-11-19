part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class InitializeNotifications extends NotificationEvent {
  final int userId;

  const InitializeNotifications(this.userId);

  @override
  List<Object> get props => [userId];
}

class LoadNotifications extends NotificationEvent {}

class MarkAsRead extends NotificationEvent {
  final String notificationId;

  const MarkAsRead(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}

class MarkAllAsRead extends NotificationEvent {}

class DeleteNotification extends NotificationEvent {
  final String notificationId;

  const DeleteNotification(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}

class ClearAllNotifications extends NotificationEvent {}

class RefreshNotifications extends NotificationEvent {}

class CreateNotification extends NotificationEvent {
  final String title;
  final String body;
  final NotificationType type;
  final Map<String, dynamic>? data;

  const CreateNotification({
    required this.title,
    required this.body,
    required this.type,
    this.data,
  });

  @override
  List<Object> get props => [title, body, type];
}
