import 'package:medicine_reminder/core/constant/url.dart';
import 'package:medicine_reminder/core/network/network_service.dart';
import 'package:medicine_reminder/features/notification/data/models/notification_model.dart';
import 'package:medicine_reminder/features/notification/data/datasources/notification_remote_datasource.dart';

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final NetworkService networkService;

  NotificationRemoteDataSourceImpl({required this.networkService});

  @override
  Future<List<NotificationModel>> fetchNotifications(int userId) async {
    try {
      final response = await networkService.get('$notificationUrl/$userId');

      if (response.statusCode == 200 || response.isSuccess) {
        // Check if response.data is null
        if (response.data == null) {
          print('Response data is null');
          return [];
        }

        // response.data is already parsed by ApiResponse
        // It contains: {"limit":20,"notifications":[...],"page":1,"unread_only":false}
        final data = response.data as Map<String, dynamic>;

        // Check if 'notifications' key exists
        if (!data.containsKey('notifications')) {
          print(
              'Data does not contain "notifications" key. Keys: ${data.keys}');
          return [];
        }

        final notificationsList = data['notifications'] as List;
        final notifications = notificationsList
            .map((json) =>
                NotificationModel.fromJson(json as Map<String, dynamic>))
            .toList();

        print('Successfully fetched ${notifications.length} notifications');
        return notifications;
      } else {
        throw Exception(
            'Failed to fetch notifications: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching notifications from remote: $e');
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  @override
  Future<List<NotificationModel>> fetchUnreadNotifications(int userId) async {
    try {
      final response =
          await networkService.get('$notificationUrl/$userId/unread');

      if (response.statusCode == 200 || response.isSuccess) {
        // Check if response.data is null
        if (response.data == null) {
          print('Response data is null');
          return [];
        }

        // response.data is already parsed by ApiResponse
        // It contains: {"limit":20,"notifications":[...],"page":1,"unread_only":false}
        final data = response.data as Map<String, dynamic>;

        // Check if 'notifications' key exists
        if (!data.containsKey('notifications')) {
          print(
              'Data does not contain "notifications" key. Keys: ${data.keys}');
          return [];
        }

        final notificationsList = data['notifications'] as List;
        final notifications = notificationsList
            .map((json) =>
                NotificationModel.fromJson(json as Map<String, dynamic>))
            .toList();

        print(
            'Successfully fetched ${notifications.length} unread notifications');
        return notifications;
      } else {
        throw Exception(
            'Failed to fetch unread notifications: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching unread notifications from remote: $e');
      throw Exception('Failed to fetch unread notifications: $e');
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      final response = await networkService.put(
        '$notificationUrl/$notificationId/read',
        body: {'is_read': true},
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
            'Failed to mark notification as read: ${response.statusCode}');
      }
    } catch (e) {
      print('Error marking notification as read on remote: $e');
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  @override
  Future<void> markAllAsRead(int userId) async {
    try {
      final response = await networkService.put(
        '/notifications/user/$userId/read-all',
        body: {'is_read': true},
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
            'Failed to mark all notifications as read: ${response.statusCode}');
      }
    } catch (e) {
      print('Error marking all notifications as read on remote: $e');
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    try {
      final response =
          await networkService.delete('/notifications/$notificationId');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
            'Failed to delete notification: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting notification on remote: $e');
      throw Exception('Failed to delete notification: $e');
    }
  }

  @override
  Future<void> clearAllNotifications(int userId) async {
    try {
      final response =
          await networkService.delete('/notifications/user/$userId');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
            'Failed to clear all notifications: ${response.statusCode}');
      }
    } catch (e) {
      print('Error clearing all notifications on remote: $e');
      throw Exception('Failed to clear all notifications: $e');
    }
  }

  @override
  Future<NotificationModel> createNotification(
      NotificationModel notification) async {
    try {
      final response = await networkService.post(
        '/notifications',
        body: notification.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        return NotificationModel.fromJson(data['data']);
      } else {
        throw Exception(
            'Failed to create notification: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating notification on remote: $e');
      throw Exception('Failed to create notification: $e');
    }
  }
}
