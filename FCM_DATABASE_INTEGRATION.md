# FCM to Database Integration

## Overview
This document explains how Firebase Cloud Messaging (FCM) notifications are automatically saved to the local SQLite database in the Medicine Reminder app.

## Architecture Flow

```
FCM Server → Firebase → App (FCM Service) → Notification Repository → SQLite Database
```

## Components

### 1. FCM Service (`lib/core/services/fcm_service.dart`)

The FCM service handles incoming notifications and saves them to the database:

#### Key Methods:
- **`setNotificationRepository(repository, userId)`**: Connects the FCM service with the notification repository and user ID
- **`_saveNotificationToDatabase(message)`**: Saves incoming FCM notifications to the database
- **`_parseNotificationType(type)`**: Converts notification type strings to enum values

#### Notification Flow:

**Foreground Notifications** (App is open and active)
- Received by: `_handleForegroundMessage()`
- Actions: 
  1. Displays local notification
  2. Saves to database via `_saveNotificationToDatabase()`

**Background Notifications** (App is in background)
- Received by: `_handleMessageOpenedApp()`
- Actions:
  1. Saves to database via `_saveNotificationToDatabase()`
  2. Routes user to appropriate screen

**Terminated Notifications** (App is completely closed)
- Received by: `firebaseMessagingBackgroundHandler()` (top-level function)
- Actions:
  1. Directly creates datasource and saves to SQLite
  2. Uses SharedPreferences to get userId (no dependency injection available)

### 2. Notification Repository (`lib/features/notification/data/repositories/notification_repository_impl.dart`)

Implements offline-first pattern:
- Saves notifications to local SQLite first
- Syncs with server when online
- Provides CRUD operations for notifications

### 3. Database Schema

**notifications table:**
```sql
CREATE TABLE notifications (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  server_id INTEGER,
  user_id INTEGER NOT NULL,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  type TEXT NOT NULL,
  data TEXT,
  is_read INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
)
```

**Indexes:**
- `idx_notifications_user_id` on `user_id`
- `idx_notifications_is_read` on `is_read`

## Initialization

In `main.dart`, the integration is set up as follows:

```dart
// 1. Core services initialization
await _initializeCoreServices();  // Initializes FCM, databases, etc.

// 2. Create NotificationBloc with dependencies
NotificationBloc createNotificationBloc(int userId) {
  // Creates datasources
  final localDataSource = NotificationLocalDataSourceImpl();
  final remoteDataSource = NotificationRemoteDataSourceImpl(...);
  
  // Creates repository
  final repository = NotificationRepositoryImpl(...);
  
  // ✅ CONNECTS FCM WITH REPOSITORY
  FCMService().setNotificationRepository(repository, userId);
  
  // Creates and returns bloc with all usecases
  return NotificationBloc(...);
}

// 3. In MultiBlocProvider
BlocProvider(create: (context) {
  // Gets userId from UserBloc state
  final userState = userBloc.state;
  int userId = 0;
  if (userState is UserLoaded) {
    userId = userState.user.userId ?? 0;
  }
  return createNotificationBloc(userId);  // ✅ Sets up complete integration
}),
```

## Data Flow

### Incoming FCM Notification:

1. **Server sends notification** via FCM
2. **Firebase delivers** to device
3. **FCM Service receives** based on app state:
   - Foreground: `_handleForegroundMessage()`
   - Background: `_handleMessageOpenedApp()`
   - Terminated: `firebaseMessagingBackgroundHandler()`
4. **Notification is saved** to database:
   ```dart
   await _saveNotificationToDatabase(message);
   ```
5. **Database stores** in `notifications` table
6. **NotificationBloc** can retrieve via usecases

### Notification Retrieval:

1. **UI requests** notifications via NotificationBloc
2. **BLoC dispatches** event (e.g., `LoadNotifications`)
3. **UseCase executes** (e.g., `GetNotifications`)
4. **Repository fetches** from local database first
5. **UI displays** notifications to user

## Background Handler Special Case

The `firebaseMessagingBackgroundHandler()` is a **top-level function** that runs in a separate isolate when the app is terminated. It cannot use dependency injection, so it:

1. Creates its own `NotificationLocalDataSourceImpl()`
2. Gets `userId` from `SharedPreferences`
3. Directly saves to SQLite database
4. Works independently of the main app instance

```dart
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  
  // Direct database access (no DI available)
  final localDataSource = NotificationLocalDataSourceImpl();
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('userId') ?? 0;
  
  // Save directly to database
  await localDataSource.createNotification(notification);
}
```

## Notification Types

Supported notification types (from `lib/features/notification/domain/entities/notification.dart`):

- `MEDICATION_REMINDER` - Reminder to take medicine
- `APPOINTMENT_REMINDER` - Doctor appointment reminder
- `REFILL_REMINDER` - Prescription refill reminder
- `HEALTH_TIP` - General health tips
- `SYSTEM_NOTIFICATION` - System messages
- `UNKNOWN` - Fallback for unrecognized types

## Key Features

✅ **Automatic Database Saving**: All FCM notifications are automatically persisted to SQLite  
✅ **Offline-First**: Works without internet connection  
✅ **Background Support**: Handles notifications even when app is terminated  
✅ **Type Safety**: Uses enums for notification types  
✅ **Clean Architecture**: Follows domain/data/presentation separation  
✅ **BLoC Pattern**: State management with 8 specialized usecases  

## Testing

To test the integration:

1. **Send test notification** from Firebase Console or your backend
2. **Check database** to verify notification was saved:
   ```dart
   final notifications = await localDataSource.getNotifications(userId);
   debugPrint('Saved notifications: ${notifications.length}');
   ```
3. **Verify in UI** that notification appears in notifications screen
4. **Test all states**:
   - App in foreground
   - App in background
   - App terminated

## Troubleshooting

**Notifications not saving:**
- Check that `setNotificationRepository()` is called in `createNotificationBloc()`
- Verify `userId` is available (not 0)
- Check database initialization in `_initializeCoreServices()`

**Background handler not working:**
- Ensure `firebase_messaging` plugin is properly configured
- Verify `firebaseMessagingBackgroundHandler` is registered in `main()`
- Check that `SharedPreferences` has saved `userId`

**Type conversion errors:**
- Ensure notification payload includes `type` field
- Verify type string matches enum values in `_parseNotificationType()`

## Related Files

- `lib/core/services/fcm_service.dart` - FCM integration
- `lib/features/notification/domain/entities/notification.dart` - Entity
- `lib/features/notification/data/datasources/notification_local_datasource_impl.dart` - SQLite
- `lib/features/notification/data/repositories/notification_repository_impl.dart` - Repository
- `lib/features/notification/presentation/bloc/notification_bloc.dart` - State management
- `lib/main.dart` - Initialization and dependency injection
