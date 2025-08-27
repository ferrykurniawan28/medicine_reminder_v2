import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medicine_reminder/features/notification/data/models/notification_model.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  // TODO: Add repository dependency injection
  // final NotificationRepository _repository;

  NotificationBloc() : super(NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkAsRead>(_onMarkAsRead);
    on<MarkAllAsRead>(_onMarkAllAsRead);
    on<DeleteNotification>(_onDeleteNotification);
    on<ClearAllNotifications>(_onClearAllNotifications);
    on<RefreshNotifications>(_onRefreshNotifications);
    on<CreateNotification>(_onCreateNotification);
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(NotificationLoading());

      // TODO: Replace with actual repository call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      // Mock data - replace with actual data from repository
      final notifications = _getMockNotifications();
      final unreadNotifications =
          notifications.where((n) => !n.isRead).toList();

      emit(NotificationLoaded(
        notifications: notifications,
        unreadNotifications: unreadNotifications,
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
      // TODO: Call repository to mark as read
      await Future.delayed(const Duration(milliseconds: 300));

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
      // TODO: Call repository to mark all as read
      await Future.delayed(const Duration(milliseconds: 500));

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
      // TODO: Call repository to delete notification
      await Future.delayed(const Duration(milliseconds: 300));

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
      // TODO: Call repository to clear all notifications
      await Future.delayed(const Duration(milliseconds: 500));

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
    // Same as load but without loading state
    add(LoadNotifications());
  }

  Future<void> _onCreateNotification(
    CreateNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      // TODO: Call repository to create notification
      await Future.delayed(const Duration(milliseconds: 300));

      // Reload notifications to show the new one
      add(LoadNotifications());
      emit(NotificationActionSuccess('Notification created'));
    } catch (e) {
      emit(NotificationError('Failed to create notification: $e'));
    }
  }

  // Mock data - replace with actual data source
  List<NotificationModel> _getMockNotifications() {
    return [
      NotificationModel(
        id: '1',
        title: 'Medicine Reminder',
        body: 'Time to take your Aspirin',
        type: NotificationType.medicineReminder,
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
        data: {'medication_id': '123'},
      ),
      NotificationModel(
        id: '2',
        title: 'Appointment Tomorrow',
        body: 'Don\'t forget your doctor appointment at 2:00 PM',
        type: NotificationType.appointmentReminder,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
        data: {'appointment_id': '456'},
      ),
      NotificationModel(
        id: '3',
        title: 'Device Alert',
        body: 'Medicine container is running low',
        type: NotificationType.deviceAlert,
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        isRead: true,
        data: {'device_id': '789'},
      ),
      NotificationModel(
        id: '4',
        title: 'Parental Alert',
        body: 'Child missed medication dose',
        type: NotificationType.parentalAlert,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
        data: {'child_id': '321'},
      ),
      NotificationModel(
        id: '5',
        title: 'FCM Test',
        body: 'This is a test notification from Firebase',
        type: NotificationType.fcmTest,
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        isRead: false,
        data: {'test_data': 'firebase_test'},
      ),
    ];
  }
}
