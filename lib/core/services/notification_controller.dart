import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicine_reminder/core/connectivity/connectivity_service.dart';
import 'package:medicine_reminder/features/reminder/domain/entities/reminder.dart';
import 'package:medicine_reminder/features/reminder/domain/entities/time.dart';
import 'package:timezone/timezone.dart' as tz;

/// Controller that manages notification scheduling
/// - Online: Server sends FCM notifications
/// - Offline: Local notifications are scheduled
class NotificationController {
  static final NotificationController _instance =
      NotificationController._internal();
  factory NotificationController() => _instance;
  NotificationController._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final ConnectivityService _connectivityService = ConnectivityService();

  StreamSubscription<bool>? _connectivitySubscription;
  bool _isInitialized = false;

  /// Initialize the notification controller
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _initializeLocalNotifications();
      _listenToConnectivityChanges();
      _isInitialized = true;

      if (kDebugMode) {
        print('NotificationController initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing NotificationController: $e');
      }
    }
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(initSettings);

    // Create notification channels for Android
    await _createNotificationChannels();
  }

  /// Create notification channels for Android
  Future<void> _createNotificationChannels() async {
    const AndroidNotificationChannel reminderChannel =
        AndroidNotificationChannel(
      'reminder_channel',
      'Medicine Reminders',
      description: 'Notifications for medicine reminders',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    const AndroidNotificationChannel appointmentChannel =
        AndroidNotificationChannel(
      'appointment_channel',
      'Appointments',
      description: 'Notifications for medical appointments',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(reminderChannel);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(appointmentChannel);
  }

  /// Listen to connectivity changes
  void _listenToConnectivityChanges() {
    _connectivitySubscription =
        _connectivityService.connectionStream.listen((isOnline) {
      if (kDebugMode) {
        print('Connectivity changed - Online: $isOnline');
      }
      _handleConnectivityChange(isOnline);
    });
  }

  /// Handle connectivity changes
  void _handleConnectivityChange(bool isOnline) {
    if (isOnline) {
      // When going online, cancel local notifications
      // Server will handle notifications via FCM
      if (kDebugMode) {
        print('Online: Server will handle notifications via FCM');
      }
    } else {
      // When going offline, we need to schedule local notifications
      // This will be triggered when reminders are loaded
      if (kDebugMode) {
        print('Offline: Local notifications will be scheduled');
      }
    }
  }

  /// Schedule notifications for a reminder
  /// - Online: Do nothing (server sends FCM)
  /// - Offline: Schedule local notifications
  Future<void> scheduleReminderNotifications(Reminder reminder) async {
    if (!_isInitialized) {
      await initialize();
    }

    final isOnline = _connectivityService.isConnected;

    if (isOnline) {
      // When online, server handles FCM notifications
      if (kDebugMode) {
        print(
            'Online: Skipping local notification scheduling for reminder ${reminder.id}');
        print('Server will send FCM notifications');
      }
      return;
    }

    // When offline, schedule local notifications
    if (kDebugMode) {
      print(
          'Offline: Scheduling local notifications for reminder ${reminder.id}');
    }

    await _scheduleLocalReminderNotifications(reminder);
  }

  /// Schedule local notifications for a reminder
  Future<void> _scheduleLocalReminderNotifications(Reminder reminder) async {
    if (reminder.id == null) return;

    try {
      // Cancel existing notifications for this reminder
      await cancelReminderNotifications(reminder.id!);

      final now = DateTime.now();

      switch (reminder.type) {
        case ReminderType.onceDaily:
        case ReminderType.twiceDaily:
        case ReminderType.multipleTimesDaily:
          await _scheduleDailyReminder(reminder, now);
          break;
        case ReminderType.specificDays:
          await _scheduleWeeklyReminder(reminder, now);
          break;
        case ReminderType.intervalhours:
        case ReminderType.intervaldays:
        case ReminderType.cyclic:
          await _scheduleIntervalReminder(reminder, now);
          break;
      }

      if (kDebugMode) {
        print('Local notifications scheduled for reminder ${reminder.id}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error scheduling local notifications: $e');
      }
    }
  }

  /// Schedule daily reminder notifications
  Future<void> _scheduleDailyReminder(Reminder reminder, DateTime now) async {
    for (int i = 0; i < reminder.times.length; i++) {
      final time = reminder.times[i];
      final notificationId = _generateNotificationId(reminder.id!, i);

      final scheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      // If time has passed today, schedule for tomorrow
      final nextScheduledDate = scheduledDate.isBefore(now)
          ? scheduledDate.add(const Duration(days: 1))
          : scheduledDate;

      await _scheduleNotification(
        id: notificationId,
        title: 'Medicine Reminder',
        body: 'Time to take ${reminder.medicineName}',
        scheduledDate: nextScheduledDate,
        payload: 'reminder_${reminder.id}',
        channelId: 'reminder_channel',
      );
    }
  }

  /// Schedule weekly reminder notifications
  Future<void> _scheduleWeeklyReminder(Reminder reminder, DateTime now) async {
    if (reminder.daysofWeek == null || reminder.daysofWeek!.isEmpty) return;

    for (int timeIndex = 0; timeIndex < reminder.times.length; timeIndex++) {
      final time = reminder.times[timeIndex];

      for (int dayIndex = 0;
          dayIndex < reminder.daysofWeek!.length;
          dayIndex++) {
        final day = reminder.daysofWeek![dayIndex];
        final notificationId = _generateNotificationId(
          reminder.id!,
          timeIndex * 7 + dayIndex,
        );

        final targetWeekday = _daysToWeekday(day);
        var scheduledDate = _getNextWeekday(targetWeekday, time);

        if (scheduledDate.isBefore(now)) {
          scheduledDate = scheduledDate.add(const Duration(days: 7));
        }

        await _scheduleNotification(
          id: notificationId,
          title: 'Medicine Reminder',
          body: 'Time to take ${reminder.medicineName}',
          scheduledDate: scheduledDate,
          payload: 'reminder_${reminder.id}',
          channelId: 'reminder_channel',
        );
      }
    }
  }

  /// Schedule interval reminder notifications
  Future<void> _scheduleIntervalReminder(
      Reminder reminder, DateTime now) async {
    if (reminder.times.isEmpty) return;

    // For interval reminders, schedule based on the first time
    // and repeat at the specified interval
    final time = reminder.times[0];
    final notificationId = _generateNotificationId(reminder.id!, 0);

    final scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    final nextScheduledDate = scheduledDate.isBefore(now)
        ? scheduledDate.add(const Duration(days: 1))
        : scheduledDate;

    await _scheduleNotification(
      id: notificationId,
      title: 'Medicine Reminder',
      body: 'Time to take ${reminder.medicineName}',
      scheduledDate: nextScheduledDate,
      payload: 'reminder_${reminder.id}',
      channelId: 'reminder_channel',
    );
  }

  /// Schedule a single notification
  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required String payload,
    required String channelId,
  }) async {
    final tz.TZDateTime scheduledTZDate =
        tz.TZDateTime.from(scheduledDate, tz.local);

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'reminder_channel',
      'Medicine Reminders',
      channelDescription: 'Notifications for medicine reminders',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      scheduledTZDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  /// Cancel notifications for a specific reminder
  Future<void> cancelReminderNotifications(int reminderId) async {
    // Cancel all notification IDs associated with this reminder
    // Since we can have multiple notifications per reminder, cancel a range
    for (int i = 0; i < 100; i++) {
      final notificationId = _generateNotificationId(reminderId, i);
      await _localNotifications.cancel(notificationId);
    }

    if (kDebugMode) {
      print('Cancelled notifications for reminder $reminderId');
    }
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
    if (kDebugMode) {
      print('All notifications cancelled');
    }
  }

  /// Show immediate notification (for testing or manual triggers)
  Future<void> showImmediateNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'reminder_channel',
      'Medicine Reminders',
      channelDescription: 'Notifications for medicine reminders',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  /// Generate unique notification ID
  int _generateNotificationId(int reminderId, int index) {
    // Combine reminder ID and index to create unique notification ID
    return (reminderId * 1000) + index;
  }

  /// Convert Days enum to weekday number
  int _daysToWeekday(Days day) {
    switch (day) {
      case Days.monday:
        return DateTime.monday;
      case Days.tuesday:
        return DateTime.tuesday;
      case Days.wednesday:
        return DateTime.wednesday;
      case Days.thursday:
        return DateTime.thursday;
      case Days.friday:
        return DateTime.friday;
      case Days.saturday:
        return DateTime.saturday;
      case Days.sunday:
        return DateTime.sunday;
    }
  }

  /// Get next occurrence of a specific weekday with time
  DateTime _getNextWeekday(int weekday, Time time) {
    final now = DateTime.now();
    final daysUntilTarget = (weekday - now.weekday + 7) % 7;
    final targetDate = now.add(Duration(days: daysUntilTarget));

    return DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
      time.hour,
      time.minute,
    );
  }

  /// Reschedule all reminders (e.g., after going offline)
  Future<void> rescheduleAllReminders(List<Reminder> reminders) async {
    if (kDebugMode) {
      print('Rescheduling ${reminders.length} reminders');
    }

    for (final reminder in reminders) {
      if (reminder.isActive) {
        await scheduleReminderNotifications(reminder);
      }
    }
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    if (kDebugMode) {
      print('NotificationController disposed');
    }
  }
}
