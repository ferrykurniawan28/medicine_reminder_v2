import 'package:medicine_reminder/features/notification/data/models/notification_model.dart';

/// Remote data source interface for notifications
abstract class NotificationRemoteDataSource {
  /// Fetch all notifications from server
  Future<List<NotificationModel>> fetchNotifications(int userId);

  /// Fetch unread notifications from server
  Future<List<NotificationModel>> fetchUnreadNotifications(int userId);

  /// Mark notification as read on server
  Future<void> markAsRead(String notificationId);

  /// Mark all notifications as read on server
  Future<void> markAllAsRead(int userId);

  /// Delete notification on server
  Future<void> deleteNotification(String notificationId);

  /// Clear all notifications on server
  Future<void> clearAllNotifications(int userId);

  /// Create notification on server
  Future<NotificationModel> createNotification(NotificationModel notification);
}
