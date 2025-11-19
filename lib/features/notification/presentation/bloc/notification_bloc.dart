import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medicine_reminder/features/notification/data/models/notification_model.dart';
import 'package:medicine_reminder/features/notification/domain/usecases/notification_usecases.dart'
    as usecases;
import 'package:medicine_reminder/features/notification/domain/entities/notification.dart'
    as entity;

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final usecases.GetNotifications getNotificationsUseCase;
  final usecases.GetUnreadNotifications getUnreadNotificationsUseCase;
  final usecases.MarkNotificationAsRead markNotificationAsReadUseCase;
  final usecases.MarkAllNotificationsAsRead markAllNotificationsAsReadUseCase;
  final usecases.DeleteNotification deleteNotificationUseCase;
  final usecases.ClearAllNotifications clearAllNotificationsUseCase;
  final usecases.CreateNotification createNotificationUseCase;
  final usecases.SyncNotifications syncNotificationsUseCase;

  int userId; // Current user ID (can be updated)

  NotificationBloc({
    required this.getNotificationsUseCase,
    required this.getUnreadNotificationsUseCase,
    required this.markNotificationAsReadUseCase,
    required this.markAllNotificationsAsReadUseCase,
    required this.deleteNotificationUseCase,
    required this.clearAllNotificationsUseCase,
    required this.createNotificationUseCase,
    required this.syncNotificationsUseCase,
    this.userId = 0,
  }) : super(NotificationInitial()) {
    on<InitializeNotifications>(_onInitializeNotifications);
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkAsRead>(_onMarkAsRead);
    on<MarkAllAsRead>(_onMarkAllAsRead);
    on<DeleteNotification>(_onDeleteNotification);
    on<ClearAllNotifications>(_onClearAllNotifications);
    on<RefreshNotifications>(_onRefreshNotifications);
    on<CreateNotification>(_onCreateNotification);
  }

  Future<void> _onInitializeNotifications(
    InitializeNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    userId = event.userId;
    // Automatically load notifications after initialization
    add(LoadNotifications());
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(NotificationLoading());

      // Fetch notifications from repository
      final notifications = await getNotificationsUseCase(userId);
      final unreadNotifications = await getUnreadNotificationsUseCase(userId);

      // Convert domain entities to models for UI
      final notificationModels = notifications.map((n) => _toModel(n)).toList();
      final unreadModels = unreadNotifications.map((n) => _toModel(n)).toList();

      emit(NotificationLoaded(
        notifications: notificationModels,
        unreadNotifications: unreadModels,
      ));
    } catch (e) {
      emit(NotificationError('Failed to load notifications: $e'));
    }
  }

  Future<void> _onMarkAsRead(
    MarkAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await markNotificationAsReadUseCase(event.notificationId);

      // Reload notifications
      add(LoadNotifications());
    } catch (e) {
      emit(NotificationError('Failed to mark notification as read: $e'));
    }
  }

  Future<void> _onMarkAllAsRead(
    MarkAllAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await markAllNotificationsAsReadUseCase(userId);

      // Reload notifications
      add(LoadNotifications());
      emit(NotificationActionSuccess('All notifications marked as read'));
    } catch (e) {
      emit(NotificationError('Failed to mark all notifications as read: $e'));
    }
  }

  Future<void> _onDeleteNotification(
    DeleteNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await deleteNotificationUseCase(event.notificationId);

      // Reload notifications
      add(LoadNotifications());
    } catch (e) {
      emit(NotificationError('Failed to delete notification: $e'));
    }
  }

  Future<void> _onClearAllNotifications(
    ClearAllNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await clearAllNotificationsUseCase(userId);

      emit(NotificationLoaded(
        notifications: [],
        unreadNotifications: [],
      ));
      emit(NotificationActionSuccess('All notifications cleared'));
    } catch (e) {
      emit(NotificationError('Failed to clear notifications: $e'));
    }
  }

  Future<void> _onRefreshNotifications(
    RefreshNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      // Sync with server first
      await syncNotificationsUseCase(userId);

      // Then reload notifications
      add(LoadNotifications());
    } catch (e) {
      // If sync fails, still try to load from local
      add(LoadNotifications());
    }
  }

  Future<void> _onCreateNotification(
    CreateNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final notification = entity.Notification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: event.title,
        message: event.body,
        type: event.type,
        createdAt: DateTime.now(),
        isRead: false,
        userId: userId,
        data: event.data,
      );

      await createNotificationUseCase(notification);

      // Reload notifications to show the new one
      add(LoadNotifications());
      emit(NotificationActionSuccess('Notification created'));
    } catch (e) {
      emit(NotificationError('Failed to create notification: $e'));
    }
  }

  // Helper method to convert domain entity to model
  NotificationModel _toModel(entity.Notification notification) {
    return NotificationModel(
      id: notification.id,
      title: notification.title,
      message: notification.message,
      type: notification.type,
      createdAt: notification.createdAt,
      isRead: notification.isRead,
      readAt: notification.readAt,
      userId: notification.userId,
      data: notification.data,
    );
  }
}
