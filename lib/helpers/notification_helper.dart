import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_reminder/core/services/fcm_service.dart';
import 'package:medicine_reminder/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:medicine_reminder/helpers/user_helper.dart';

class NotificationHelper {
  /// Initialize NotificationBloc with userId and connect FCM service
  /// This should be called when the user logs in or when userId becomes available
  static void initializeWithUserId(BuildContext context) {
    UserHelper.executeWithUserId(context, (int userId) {
      final notificationBloc = context.read<NotificationBloc>();

      // Initialize the bloc with userId
      notificationBloc.add(InitializeNotifications(userId));

      // Connect FCM service with the notification repository
      _connectFCMService(notificationBloc, userId);

      debugPrint('✅ NotificationBloc initialized with userId: $userId');
    });
  }

  /// Connect FCM service with notification repository
  static void _connectFCMService(NotificationBloc bloc, int userId) {
    try {
      // Get repository from the bloc's usecases
      final repository = bloc.getNotificationsUseCase.repository;

      // Connect FCM service
      FCMService().setNotificationRepository(repository, userId);

      debugPrint('✅ FCM service connected to notification repository');
    } catch (e) {
      debugPrint('❌ Failed to connect FCM service: $e');
    }
  }

  /// Load notifications for the current user
  static void loadNotifications(BuildContext context) {
    final notificationBloc = context.read<NotificationBloc>();

    if (notificationBloc.userId > 0) {
      notificationBloc.add(LoadNotifications());
    } else {
      // If userId not set, initialize first
      initializeWithUserId(context);
    }
  }

  /// Refresh notifications (sync with server)
  static void refreshNotifications(BuildContext context) {
    final notificationBloc = context.read<NotificationBloc>();

    if (notificationBloc.userId > 0) {
      notificationBloc.add(RefreshNotifications());
    }
  }

  /// Mark notification as read
  static void markAsRead(BuildContext context, String notificationId) {
    context.read<NotificationBloc>().add(MarkAsRead(notificationId));
  }

  /// Mark all notifications as read
  static void markAllAsRead(BuildContext context) {
    context.read<NotificationBloc>().add(MarkAllAsRead());
  }

  /// Delete a notification
  static void deleteNotification(BuildContext context, String notificationId) {
    context.read<NotificationBloc>().add(DeleteNotification(notificationId));
  }

  /// Clear all notifications
  static void clearAllNotifications(BuildContext context) {
    context.read<NotificationBloc>().add(ClearAllNotifications());
  }
}
