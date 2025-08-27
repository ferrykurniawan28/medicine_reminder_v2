# Firebase Cloud Messaging (FCM) Setup Guide

## Overview
Firebase Cloud Messaging (FCM) has been successfully integrated into your Medicine Reminder app. This document explains how the implementation works and how to use it.

## 📁 File Structure

```
lib/
├── core/
│   └── services/
│       ├── fcm_service.dart              # Main FCM service
│       └── fcm_token_manager.dart        # Token management utilities
└── ui/
    └── screens/
        └── fcm_test_screen.dart          # FCM testing interface
```

## 🚀 What's Been Implemented

### 1. FCM Service (`fcm_service.dart`)
- **Token Generation**: Automatically generates and manages FCM tokens
- **Permission Handling**: Requests notification permissions on iOS/Android
- **Message Handlers**: Handles foreground, background, and terminated app messages
- **Local Notifications**: Shows notifications when app is in foreground
- **Topic Management**: Subscribe/unsubscribe from notification topics
- **Token Persistence**: Saves tokens to SharedPreferences

### 2. FCM Token Manager (`fcm_token_manager.dart`)
- **Server Integration**: Send tokens to your backend server
- **User Management**: Register/unregister tokens for specific users
- **Topic Subscriptions**: Manage parental and medication reminder topics
- **Error Handling**: Comprehensive error handling and logging

### 3. Android Configuration
- **Permissions**: Added necessary FCM permissions to AndroidManifest.xml
- **Service Configuration**: Configured FCM service for background messages
- **Intent Filters**: Set up notification click handling

### 4. Test Interface (`fcm_test_screen.dart`)
- **Token Display**: Shows current FCM token
- **Topic Management**: Test topic subscription/unsubscription
- **Status Monitoring**: Real-time FCM status updates
- **Copy Token**: Easy token copying for testing

## 🔧 How to Use FCM in Your App

### Initialize FCM (Already Done)
```dart
// In main.dart - already implemented
await FCMService().initialize();
```

### Register User Token with Server
```dart
import 'package:medicine_reminder/core/services/fcm_token_manager.dart';

// When user logs in
final tokenManager = FCMTokenManager();
await tokenManager.registerTokenForUser(userId);

// Subscribe to relevant topics
await tokenManager.subscribeToMedicationReminders();
await tokenManager.subscribeToParentalNotifications(parentalId);
```

### Send Notifications from Server
Your backend can send notifications using the FCM Admin SDK or REST API:

```json
{
  "to": "FCM_TOKEN_HERE",
  "notification": {
    "title": "Medicine Reminder",
    "body": "Time to take your medication!"
  },
  "data": {
    "type": "reminder",
    "reminder_id": "123",
    "medication_name": "Aspirin"
  }
}
```

### Topic-Based Notifications
```json
{
  "to": "/topics/medicine_reminders",
  "notification": {
    "title": "Daily Reminder",
    "body": "Don't forget your evening medications"
  },
  "data": {
    "type": "general_reminder"
  }
}
```

## 🧪 Testing FCM

### 1. Access Test Screen
Navigate to `/fcm-test` in your app to see the FCM test interface.

### 2. Using Firebase Console
1. Go to Firebase Console → Your Project → Cloud Messaging
2. Click "Send your first message"
3. Enter title and message text
4. In "Target" section, select "Single device"
5. Paste the FCM token from your test screen
6. Send the message

### 3. Testing Different App States
- **Foreground**: App is open and visible
- **Background**: App is running but not visible
- **Terminated**: App is completely closed

## 📱 Platform-Specific Notes

### Android
- Notifications work out of the box
- Background notifications are handled automatically
- Custom notification channel is created for better organization

### iOS (Future Implementation)
- Will require additional iOS-specific configuration
- APNs certificate setup needed
- iOS notification permissions are requested automatically

## 🔗 Integration Points

### With User Authentication
```dart
// When user logs in
final userBloc = BlocProvider.of<UserBloc>(context);
userBloc.stream.listen((state) {
  if (state is UserLoaded) {
    FCMTokenManager().registerTokenForUser(state.user.id);
  }
});
```

### With Parental System
```dart
// When viewing parental details
await FCMTokenManager().subscribeToParentalNotifications(parentalId);
```

### With Reminder System
```dart
// Notification action handling
Future<void> _handleNotificationAction(RemoteMessage message) async {
  final String? notificationType = message.data['type'];
  
  switch (notificationType) {
    case 'reminder':
      final String? reminderId = message.data['reminder_id'];
      // Navigate to reminder details
      Modular.to.pushNamed('/reminder/detail', arguments: reminderId);
      break;
    // ... other cases
  }
}
```

## 🛠️ Backend Integration

### Required API Endpoints
Your backend should implement these endpoints:

1. **POST /api/fcm/register-token**
   ```json
   {
     "user_id": 123,
     "fcm_token": "token_here",
     "platform": "android",
     "device_type": "parental"
   }
   ```

2. **POST /api/fcm/unregister-token**
   ```json
   {
     "user_id": 123,
     "fcm_token": "token_here"
   }
   ```

### Database Schema Suggestion
```sql
CREATE TABLE fcm_tokens (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    token VARCHAR(255) NOT NULL,
    platform VARCHAR(20),
    device_type VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, token)
);
```

## 🔍 Troubleshooting

### Common Issues
1. **No FCM Token**: Ensure Firebase is properly initialized
2. **Permissions Denied**: Check if notification permissions are granted
3. **Background Messages Not Working**: Verify background handler is set
4. **Token Not Persisting**: Check SharedPreferences implementation

### Debug Logs
Enable debug mode to see FCM logs:
```dart
if (kDebugMode) {
  print('FCM Token: ${FCMService().fcmToken}');
}
```

## 📋 Next Steps

### Immediate Actions
1. **Test FCM**: Use the test screen to verify token generation
2. **Backend Setup**: Implement the required API endpoints
3. **Production Testing**: Test with real notifications from your server

### Future Enhancements
1. **Rich Notifications**: Add images, actions, and custom sounds
2. **Notification Categories**: Create different types for reminders vs appointments
3. **Analytics**: Track notification open rates and user engagement
4. **Localization**: Support multiple languages for notifications

## 🎯 Best Practices

### Security
- Never log FCM tokens in production
- Validate all incoming notification data
- Implement rate limiting on your server

### User Experience
- Request permissions at appropriate times
- Provide clear notification settings
- Allow users to customize notification types

### Performance
- Handle notifications efficiently
- Don't perform heavy operations in notification handlers
- Cache notification data appropriately

## 📞 Support
If you need help with FCM implementation or encounter issues, the FCM service includes comprehensive error logging to help diagnose problems.

For testing, you can always navigate to `/fcm-test` in your app to check the current FCM status and token.
