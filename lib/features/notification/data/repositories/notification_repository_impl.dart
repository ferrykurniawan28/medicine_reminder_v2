import 'package:medicine_reminder/features/notification/data/datasources/notification_local_datasource.dart';
import 'package:medicine_reminder/features/notification/data/datasources/notification_remote_datasource.dart';
import 'package:medicine_reminder/features/notification/data/models/notification_model.dart';
import 'package:medicine_reminder/features/notification/domain/entities/notification.dart';
import 'package:medicine_reminder/features/notification/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource localDataSource;
  final NotificationRemoteDataSource remoteDataSource;
  final bool Function()? isOnline;

  NotificationRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    this.isOnline,
  });

  @override
  Future<List<Notification>> getNotifications(int userId) async {
    // Offline-first: always read from local first
    final localNotifications = await localDataSource.getNotifications(userId);

    // If online, sync from server
    if (isOnline != null && isOnline!()) {
      try {
        await syncNotifications(userId);
        // Return fresh data from local after sync
        final syncedNotifications =
            await localDataSource.getNotifications(userId);
        return syncedNotifications.map(_toEntity).toList();
      } catch (e) {
        print('Error syncing notifications: $e');
        // Fallback to local data
        return localNotifications.map(_toEntity).toList();
      }
    }

    return localNotifications.map(_toEntity).toList();
  }

  @override
  Future<List<Notification>> getUnreadNotifications(int userId) async {
    // Offline-first: always read from local first
    final localNotifications =
        await localDataSource.getUnreadNotifications(userId);

    // If online, sync from server
    if (isOnline != null && isOnline!()) {
      try {
        await syncNotifications(userId);
        // Return fresh data from local after sync
        final syncedNotifications =
            await localDataSource.getUnreadNotifications(userId);
        return syncedNotifications.map(_toEntity).toList();
      } catch (e) {
        print('Error syncing unread notifications: $e');
        // Fallback to local data
        return localNotifications.map(_toEntity).toList();
      }
    }

    return localNotifications.map(_toEntity).toList();
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    // Always update local first (offline-first)
    await localDataSource.markAsRead(notificationId);

    // If online, sync with server
    if (isOnline != null && isOnline!()) {
      try {
        await remoteDataSource.markAsRead(notificationId);
      } catch (e) {
        print('Error marking notification as read on remote: $e');
        // Local update succeeded, will sync later
      }
    }
  }

  @override
  Future<void> markAllAsRead(int userId) async {
    // Always update local first (offline-first)
    await localDataSource.markAllAsRead(userId);

    // If online, sync with server
    if (isOnline != null && isOnline!()) {
      try {
        await remoteDataSource.markAllAsRead(userId);
      } catch (e) {
        print('Error marking all notifications as read on remote: $e');
        // Local update succeeded, will sync later
      }
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    // Always delete local first (offline-first)
    await localDataSource.deleteNotification(notificationId);

    // If online, delete from server
    if (isOnline != null && isOnline!()) {
      try {
        await remoteDataSource.deleteNotification(notificationId);
      } catch (e) {
        print('Error deleting notification on remote: $e');
        // Local deletion succeeded, will sync later
      }
    }
  }

  @override
  Future<void> clearAllNotifications(int userId) async {
    // Always clear local first (offline-first)
    await localDataSource.clearAllNotifications(userId);

    // If online, clear on server
    if (isOnline != null && isOnline!()) {
      try {
        await remoteDataSource.clearAllNotifications(userId);
      } catch (e) {
        print('Error clearing all notifications on remote: $e');
        // Local clearing succeeded, will sync later
      }
    }
  }

  @override
  Future<Notification> createNotification(Notification notification) async {
    final model = _toModel(notification);

    // If online, create on server first then save to local
    if (isOnline != null && isOnline!()) {
      try {
        final createdModel = await remoteDataSource.createNotification(model);
        await localDataSource.saveNotification(createdModel);
        return _toEntity(createdModel);
      } catch (e) {
        print('Error creating notification on remote: $e');
        // Fallback: save to local only
        await localDataSource.saveNotification(model);
        return _toEntity(model);
      }
    } else {
      // If offline, save to local only
      await localDataSource.saveNotification(model);
      return _toEntity(model);
    }
  }

  @override
  Future<void> syncNotifications(int userId) async {
    if (isOnline == null || !isOnline!()) {
      print('Cannot sync notifications: offline');
      return;
    }

    try {
      // Fetch notifications from server
      final remoteNotifications =
          await remoteDataSource.fetchNotifications(userId);

      // Save to local database
      await localDataSource.saveNotifications(remoteNotifications);

      print(
          'Notifications synced successfully: ${remoteNotifications.length} notifications');
    } catch (e) {
      print('Error syncing notifications: $e');
      throw Exception('Failed to sync notifications: $e');
    }
  }

  // Helper methods to convert between domain entity and data model
  Notification _toEntity(NotificationModel model) {
    return Notification(
      id: model.id,
      title: model.title,
      message: model.message,
      type: model.type,
      createdAt: model.createdAt,
      isRead: model.isRead,
      readAt: model.readAt,
      userId: model.userId,
      data: model.data,
    );
  }

  NotificationModel _toModel(Notification entity) {
    return NotificationModel(
      id: entity.id,
      title: entity.title,
      message: entity.message,
      type: entity.type,
      createdAt: entity.createdAt,
      isRead: entity.isRead,
      readAt: entity.readAt,
      userId: entity.userId,
      data: entity.data,
    );
  }
}
