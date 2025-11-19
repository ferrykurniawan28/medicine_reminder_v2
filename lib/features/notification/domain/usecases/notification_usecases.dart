import 'package:medicine_reminder/features/notification/domain/entities/notification.dart';
import 'package:medicine_reminder/features/notification/domain/repositories/notification_repository.dart';

/// Use case for getting all notifications
class GetNotifications {
  final NotificationRepository repository;

  GetNotifications(this.repository);

  Future<List<Notification>> call(int userId) async {
    return await repository.getNotifications(userId);
  }
}

/// Use case for getting unread notifications
class GetUnreadNotifications {
  final NotificationRepository repository;

  GetUnreadNotifications(this.repository);

  Future<List<Notification>> call(int userId) async {
    return await repository.getUnreadNotifications(userId);
  }
}

/// Use case for marking notification as read
class MarkNotificationAsRead {
  final NotificationRepository repository;

  MarkNotificationAsRead(this.repository);

  Future<void> call(String notificationId) async {
    await repository.markAsRead(notificationId);
  }
}

/// Use case for marking all notifications as read
class MarkAllNotificationsAsRead {
  final NotificationRepository repository;

  MarkAllNotificationsAsRead(this.repository);

  Future<void> call(int userId) async {
    await repository.markAllAsRead(userId);
  }
}

/// Use case for deleting a notification
class DeleteNotification {
  final NotificationRepository repository;

  DeleteNotification(this.repository);

  Future<void> call(String notificationId) async {
    await repository.deleteNotification(notificationId);
  }
}

/// Use case for clearing all notifications
class ClearAllNotifications {
  final NotificationRepository repository;

  ClearAllNotifications(this.repository);

  Future<void> call(int userId) async {
    await repository.clearAllNotifications(userId);
  }
}

/// Use case for creating a notification
class CreateNotification {
  final NotificationRepository repository;

  CreateNotification(this.repository);

  Future<Notification> call(Notification notification) async {
    return await repository.createNotification(notification);
  }
}

/// Use case for syncing notifications from server
class SyncNotifications {
  final NotificationRepository repository;

  SyncNotifications(this.repository);

  Future<void> call(int userId) async {
    await repository.syncNotifications(userId);
  }
}
