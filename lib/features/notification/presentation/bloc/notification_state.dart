part of 'notification_bloc.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

final class NotificationInitial extends NotificationState {}

final class NotificationLoading extends NotificationState {}

final class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  final List<NotificationModel> unreadNotifications;

  const NotificationLoaded({
    required this.notifications,
    required this.unreadNotifications,
  });

  @override
  List<Object> get props => [notifications, unreadNotifications];
}

final class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object> get props => [message];
}

final class NotificationActionSuccess extends NotificationState {
  final String message;

  const NotificationActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}
