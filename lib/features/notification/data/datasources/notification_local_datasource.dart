import 'package:medicine_reminder/features/notification/data/models/notification_model.dart';

/// Local data source interface for notifications
abstract class NotificationLocalDataSource {
  /// Get all notifications from local database
  Future<List<NotificationModel>> getNotifications(int userId);

  /// Get unread notifications from local database
  Future<List<NotificationModel>> getUnreadNotifications(int userId);

  /// Save notification to local database
  Future<void> saveNotification(NotificationModel notification);

  /// Save multiple notifications to local database
  Future<void> saveNotifications(List<NotificationModel> notifications);

  /// Update notification in local database
  Future<void> updateNotification(NotificationModel notification);

  /// Mark notification as read
  Future<void> markAsRead(String notificationId);

  /// Mark all notifications as read
  Future<void> markAllAsRead(int userId);

  /// Delete notification from local database
  Future<void> deleteNotification(String notificationId);

  /// Clear all notifications for a user
  Future<void> clearAllNotifications(int userId);

  /// Check if notification exists
  Future<bool> notificationExists(String notificationId);
}
