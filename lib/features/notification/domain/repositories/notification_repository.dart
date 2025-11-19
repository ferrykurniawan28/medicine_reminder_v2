import 'package:medicine_reminder/features/notification/domain/entities/notification.dart';

/// Repository interface for notification operations
abstract class NotificationRepository {
  /// Get all notifications for a user
  Future<List<Notification>> getNotifications(int userId);

  /// Get unread notifications for a user
  Future<List<Notification>> getUnreadNotifications(int userId);

  /// Mark a notification as read
  Future<void> markAsRead(String notificationId);

  /// Mark all notifications as read for a user
  Future<void> markAllAsRead(int userId);

  /// Delete a notification
  Future<void> deleteNotification(String notificationId);

  /// Clear all notifications for a user
  Future<void> clearAllNotifications(int userId);

  /// Create a new notification
  Future<Notification> createNotification(Notification notification);

  /// Sync notifications from server
  Future<void> syncNotifications(int userId);
}
