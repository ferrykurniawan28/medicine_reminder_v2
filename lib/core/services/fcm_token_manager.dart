import 'package:medicine_reminder/core/constant/url.dart';
import 'package:medicine_reminder/core/services/fcm_service.dart';
import 'package:medicine_reminder/core/network/network_service.dart';
import 'package:flutter/foundation.dart';

class FCMTokenManager {
  static final FCMTokenManager _instance = FCMTokenManager._internal();
  factory FCMTokenManager() => _instance;
  FCMTokenManager._internal();

  final NetworkService _networkService = NetworkService();
  final FCMService _fcmService = FCMService();

  /// Send FCM token to server for a specific user
  Future<bool> registerTokenForUser(int userId) async {
    try {
      final token = _fcmService.fcmToken;
      if (token == null) {
        if (kDebugMode) {
          print('FCM token not available');
        }
        return false;
      }

      // Prepare the data to send to your server
      final data = {
        'fcm_token': token,
      };

      // Send to your server endpoint
      final response = await _networkService.put(
        '$fcmUrl/$userId',
        body: data,
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('FCM token registered successfully for user $userId');
        }
        return true;
      } else {
        if (kDebugMode) {
          print('Failed to register FCM token: ${response.statusCode}');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error registering FCM token: $e');
      }
      return false;
    }
  }

  /// Remove FCM token from server when user logs out
  Future<bool> unregisterTokenForUser(int userId) async {
    try {
      final token = _fcmService.fcmToken;
      if (token == null) {
        return true; // No token to unregister
      }

      final data = {
        'fcm_token': token,
      };

      final response = await _networkService.put(
        '$fcmUrl/$userId',
        body: data,
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('FCM token unregistered successfully for user $userId');
        }
        return true;
      } else {
        if (kDebugMode) {
          print('Failed to unregister FCM token: ${response.statusCode}');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error unregistering FCM token: $e');
      }
      return false;
    }
  }

  /// Subscribe user to parental notifications
  Future<bool> subscribeToParentalNotifications(int parentalId) async {
    try {
      await _fcmService.subscribeToTopic('parental_$parentalId');
      await _fcmService.subscribeToTopic('medicine_reminders');

      if (kDebugMode) {
        print(
            'Subscribed to parental notifications for parental ID: $parentalId');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error subscribing to parental notifications: $e');
      }
      return false;
    }
  }

  /// Unsubscribe from parental notifications
  Future<bool> unsubscribeFromParentalNotifications(int parentalId) async {
    try {
      await _fcmService.unsubscribeFromTopic('parental_$parentalId');

      if (kDebugMode) {
        print(
            'Unsubscribed from parental notifications for parental ID: $parentalId');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error unsubscribing from parental notifications: $e');
      }
      return false;
    }
  }

  /// Subscribe to medication reminder notifications
  Future<bool> subscribeToMedicationReminders() async {
    try {
      await _fcmService.subscribeToTopic('medication_reminders');
      await _fcmService.subscribeToTopic('appointment_reminders');

      if (kDebugMode) {
        print('Subscribed to medication and appointment reminders');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error subscribing to medication reminders: $e');
      }
      return false;
    }
  }

  /// Get current FCM token
  String? getCurrentToken() {
    return _fcmService.fcmToken;
  }

  /// Check if FCM is properly initialized
  bool isInitialized() {
    return _fcmService.fcmToken != null;
  }
}
