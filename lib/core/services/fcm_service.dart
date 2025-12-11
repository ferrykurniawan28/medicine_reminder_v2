import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:medicine_reminder/features/notification/domain/repositories/notification_repository.dart';
import 'package:medicine_reminder/features/notification/domain/entities/notification.dart'
    as entity;
import 'package:medicine_reminder/features/notification/data/models/notification_model.dart';
import 'package:medicine_reminder/features/notification/data/datasources/notification_local_datasource_impl.dart';

class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  NotificationRepository? _notificationRepository;
  int? _currentUserId;

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  /// Set the notification repository for saving notifications
  void setNotificationRepository(
      NotificationRepository repository, int userId) {
    _notificationRepository = repository;
    _currentUserId = userId;
  }

  /// Initialize FCM service
  Future<void> initialize() async {
    try {
      // Initialize local notifications
      await _initializeLocalNotifications();

      // Request notification permissions
      await _requestPermissions();

      // Get FCM token
      await _getFCMToken();

      // Configure message handlers
      _configureMessageHandlers();

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen(_onTokenRefresh);

      if (kDebugMode) {
        print('FCM Service initialized successfully');
        print('FCM Token: $_fcmToken');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing FCM service: $e');
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

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    await _createNotificationChannel();
  }

  /// Create notification channel for Android
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'medicine_reminder_channel',
      'Medicine Reminders',
      description: 'Notifications for medicine reminders',
      importance: Importance.high,
      playSound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    final NotificationSettings settings =
        await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );

    if (kDebugMode) {
      print('Notification permission status: ${settings.authorizationStatus}');
    }
  }

  /// Get FCM token
  Future<void> _getFCMToken() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken();
      if (_fcmToken != null) {
        // Save token to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcm_token', _fcmToken!);

        if (kDebugMode) {
          print('FCM Token obtained: $_fcmToken');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting FCM token: $e');
      }
    }
  }

  /// Configure message handlers
  void _configureMessageHandlers() {
    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle messages when app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Handle messages when app is opened from terminated state
    _handleInitialMessage();
  }

  /// Handle foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    if (kDebugMode) {
      print('Received foreground message: ${message.messageId}');
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
    }

    // Save notification to database
    await _saveNotificationToDatabase(message);

    // Show local notification when app is in foreground
    await _showLocalNotification(message);
  }

  /// Handle message when app is opened from background
  Future<void> _handleMessageOpenedApp(RemoteMessage message) async {
    if (kDebugMode) {
      print('App opened from background message: ${message.messageId}');
    }

    // Save notification to database
    await _saveNotificationToDatabase(message);

    // Handle navigation or other actions based on message data
    await _handleNotificationAction(message);
  }

  /// Handle initial message when app is opened from terminated state
  Future<void> _handleInitialMessage() async {
    final RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();

    if (initialMessage != null) {
      if (kDebugMode) {
        print(
            'App opened from terminated state message: ${initialMessage.messageId}');
      }

      // Save notification to database
      await _saveNotificationToDatabase(initialMessage);

      // Handle navigation or other actions based on message data
      await _handleNotificationAction(initialMessage);
    }
  }

  /// Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final RemoteNotification? notification = message.notification;

    if (notification != null) {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'medicine_reminder_channel',
        'Medicine Reminders',
        channelDescription: 'Notifications for medicine reminders',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
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
        notification.hashCode,
        notification.title,
        notification.body,
        notificationDetails,
        payload: jsonEncode(message.data),
      );
    }
  }

  /// Handle notification action (navigation, etc.)
  Future<void> _handleNotificationAction(RemoteMessage message) async {
    final Map<String, dynamic> data = message.data;

    // Handle different notification types based on data
    final String? notificationType = data['type'];
    final String? route = data['route']; // Custom route parameter

    switch (notificationType) {
      case 'medicine_reminder_due':
        // // Navigate to reminder details
        // final String? reminderId = data['reminder_id'];
        // if (reminderId != null) {
        //   _navigateToPage('/reminder_detail', {'id': reminderId});
        // } else {
        //   _navigateToPage('/reminders'); // Default to reminders list
        // }

        // navigate to take medicine page
        final String? reminderId = data['reminder_id'];
        if (reminderId != null) {
          _navigateToPage('/take_medicine', {'id': reminderId});
        } else {
          _navigateToPage('/home'); // Default to reminders list
        }
        break;
      case 'appointment':
        // Navigate to appointment details
        final String? appointmentId = data['appointment_id'];
        if (appointmentId != null) {
          _navigateToPage('/appointment_detail', {'id': appointmentId});
        } else {
          _navigateToPage('/appointments'); // Default to appointments list
        }
        break;
      case 'medicine':
        // Navigate to medicine details
        final String? medicineId = data['medicine_id'];
        if (medicineId != null) {
          _navigateToPage('/medicine_detail', {'id': medicineId});
        } else {
          _navigateToPage('/medicines'); // Default to medicines list
        }
        break;
      case 'custom':
        // Handle custom routes
        if (route != null) {
          final Map<String, String> params = {};
          // Parse additional parameters if needed
          data.forEach((key, value) {
            if (key != 'type' && key != 'route') {
              params[key] = value.toString();
            }
          });
          _navigateToPage(route, params);
        }
        break;
      default:
        // Default action - navigate to home
        _navigateToPage('/home');
        if (kDebugMode) {
          print('Unknown notification type: $notificationType');
        }
    }
  }

  /// Navigate to a specific page
  void _navigateToPage(String route, [Map<String, String>? params]) {
    // Use a global navigator key or context
    // You'll need to implement this based on your routing system

    if (kDebugMode) {
      print('Navigating to: $route with params: $params');
    }

    // Example implementation using Modular (since you're using it)
    try {
      if (params != null && params.isNotEmpty) {
        Modular.to.pushNamed(route, arguments: params);
      } else {
        Modular.to.pushNamed(route);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Navigation error: $e');
      }
      // Fallback to home if navigation fails
      Modular.to.pushNamed('/home');
    }
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(response.payload!);
        final RemoteMessage message = RemoteMessage(
          messageId: DateTime.now().millisecondsSinceEpoch.toString(),
          data: data,
        );
        _handleNotificationAction(message);
      } catch (e) {
        if (kDebugMode) {
          print('Error handling notification tap: $e');
        }
      }
    }
  }

  /// Handle token refresh
  void _onTokenRefresh(String token) {
    _fcmToken = token;
    _saveFCMToken(token);

    if (kDebugMode) {
      print('FCM Token refreshed: $token');
    }

    // TODO: Send updated token to your server
  }

  /// Save FCM token to SharedPreferences
  Future<void> _saveFCMToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', token);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving FCM token: $e');
      }
    }
  }

  /// Get saved FCM token from SharedPreferences
  Future<String?> getSavedFCMToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('fcm_token');
    } catch (e) {
      if (kDebugMode) {
        print('Error getting saved FCM token: $e');
      }
      return null;
    }
  }

  /// Send FCM token to server
  Future<void> sendTokenToServer(String? userId) async {
    if (_fcmToken == null || userId == null) return;

    try {
      // TODO: Implement API call to send token to your server
      // Example:
      // await ApiService.sendFCMToken(userId, _fcmToken!);

      if (kDebugMode) {
        print('Sending FCM token to server for user: $userId');
        print('Token: $_fcmToken');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending FCM token to server: $e');
      }
    }
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      if (kDebugMode) {
        print('Subscribed to topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error subscribing to topic $topic: $e');
      }
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      if (kDebugMode) {
        print('Unsubscribed from topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error unsubscribing from topic $topic: $e');
      }
    }
  }

  /// Clear all notifications
  Future<void> clearAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  /// Save notification to database
  Future<void> _saveNotificationToDatabase(RemoteMessage message) async {
    if (_notificationRepository == null || _currentUserId == null) {
      if (kDebugMode) {
        print('Notification repository not set, skipping database save');
      }
      return;
    }

    try {
      final notification = message.notification;
      if (notification == null) {
        if (kDebugMode) {
          print('No notification data in message, skipping database save');
        }
        return;
      }

      // Determine notification type from data
      final notificationType = _parseNotificationType(message.data['type']);

      // Create notification entity
      final notificationEntity = entity.Notification(
        id: message.messageId ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: notification.title ?? 'Notification',
        message: notification.body ?? '',
        type: notificationType,
        createdAt: DateTime.now(),
        isRead: false,
        userId: _currentUserId,
        data: message.data,
      );

      // Save to database via repository
      await _notificationRepository!.createNotification(notificationEntity);

      if (kDebugMode) {
        print('Notification saved to database: ${notificationEntity.id}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving notification to database: $e');
      }
    }
  }

  /// Parse notification type from string
  NotificationType _parseNotificationType(dynamic type) {
    if (type == null) return NotificationType.general;

    final typeStr = type.toString().toLowerCase();

    switch (typeStr) {
      case 'medicine_reminder_due':
      case 'medicine_due':
        return NotificationType.medicineReminderDue;
      case 'medicine_reminder':
      case 'reminder':
        return NotificationType.medicineReminder;
      case 'appointment_reminder':
      case 'appointment':
        return NotificationType.appointmentReminder;
      case 'device_alert':
      case 'device':
        return NotificationType.deviceAlert;
      case 'parental_alert':
      case 'parental':
        return NotificationType.parentalAlert;
      case 'fcm_test':
      case 'test':
        return NotificationType.fcmTest;
      default:
        return NotificationType.general;
    }
  }

  /// Clear specific notification
  Future<void> clearNotification(int id) async {
    await _localNotifications.cancel(id);
  }
}

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase if not already done
  // await Firebase.initializeApp();

  if (kDebugMode) {
    print('Background message received: ${message.messageId}');
    print('Message data: ${message.data}');
  }

  // Save notification to database
  try {
    // Import datasources directly since we can't inject dependencies in top-level function
    final localDataSource = NotificationLocalDataSourceImpl();
    final notification = message.notification;

    if (notification != null) {
      // Get user ID from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      if (userId != null) {
        // Parse notification type
        final typeStr = message.data['type']?.toString() ?? 'general';
        final notificationType = NotificationTypeExtension.fromString(typeStr);

        // Create and save notification
        final notificationModel = NotificationModel(
          id: message.messageId ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          title: notification.title ?? 'Notification',
          message: notification.body ?? '',
          type: notificationType,
          createdAt: DateTime.now(),
          isRead: false,
          userId: userId,
          data: message.data,
        );

        await localDataSource.saveNotification(notificationModel);

        if (kDebugMode) {
          print(
              'Background notification saved to database: ${notificationModel.id}');
        }
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error saving background notification to database: $e');
    }
  }
}
