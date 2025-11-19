# Notification Feature - Clean Architecture Implementation

## 📁 Project Structure

```
lib/features/notification/
├── data/
│   ├── datasources/
│   │   ├── notification_local_datasource.dart          # Local datasource interface
│   │   ├── notification_local_datasource_impl.dart     # SQLite implementation
│   │   ├── notification_remote_datasource.dart         # Remote datasource interface
│   │   └── notification_remote_datasource_impl.dart    # API implementation
│   ├── models/
│   │   └── notification_model.dart                     # Data model
│   └── repositories/
│       └── notification_repository_impl.dart           # Repository implementation
├── domain/
│   ├── entities/
│   │   └── notification.dart                           # Domain entity
│   ├── repositories/
│   │   └── notification_repository.dart                # Repository interface
│   └── usecases/
│       └── notification_usecases.dart                  # All use cases
└── presentation/
    ├── bloc/
    │   ├── notification_bloc.dart                      # BLoC
    │   ├── notification_event.dart                     # Events
    │   └── notification_state.dart                     # States
    ├── pages/
    │   └── notification.dart                           # Notification page
    └── widgets/
        └── notification_widgets.dart                   # Notification widgets
```

## 🎯 Features Implemented

### ✅ Domain Layer
- **Entity**: `Notification` - Pure business logic entity
- **Repository Interface**: Defines contracts for data operations
- **Use Cases**: 
  - `GetNotifications` - Fetch all notifications
  - `GetUnreadNotifications` - Fetch unread notifications
  - `MarkNotificationAsRead` - Mark single notification as read
  - `MarkAllNotificationsAsRead` - Mark all as read
  - `DeleteNotification` - Delete single notification
  - `ClearAllNotifications` - Clear all notifications
  - `CreateNotification` - Create new notification
  - `SyncNotifications` - Sync with server

### ✅ Data Layer
- **Local Datasource (SQLite)**:
  - Table: `notifications`
  - Indexes for performance on `user_id` and `is_read`
  - CRUD operations
  - Batch operations

- **Remote Datasource (API)**:
  - Fetch notifications from server
  - Mark as read on server
  - Delete notifications on server
  - Create notifications on server

- **Repository Implementation**:
  - **Offline-first architecture**
  - Automatic sync when online
  - Local caching
  - Fallback to local data on error

### ✅ Presentation Layer
- **BLoC**: State management with use cases
- **Events**: User actions
- **States**: UI states
- **Pages & Widgets**: UI components

## 🚀 Setup Instructions

### 1. Initialize the NotificationBloc

In your dependency injection setup (main.dart or module file):

```dart
import 'package:medicine_reminder/features/notification/data/datasources/notification_local_datasource_impl.dart';
import 'package:medicine_reminder/features/notification/data/datasources/notification_remote_datasource_impl.dart';
import 'package:medicine_reminder/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:medicine_reminder/features/notification/domain/repositories/notification_repository.dart';
import 'package:medicine_reminder/features/notification/domain/usecases/notification_usecases.dart' as usecases;
import 'package:medicine_reminder/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:medicine_reminder/core/network/network_service.dart';
import 'package:medicine_reminder/core/connectivity/connectivity_service.dart';

// Initialize datasources
final notificationLocalDataSource = NotificationLocalDataSourceImpl();
final notificationRemoteDataSource = NotificationRemoteDataSourceImpl(
  networkService: NetworkService(),
);

// Initialize repository
final notificationRepository = NotificationRepositoryImpl(
  localDataSource: notificationLocalDataSource,
  remoteDataSource: notificationRemoteDataSource,
  isOnline: () => ConnectivityService().isConnected,
);

// Initialize use cases
final getNotifications = usecases.GetNotifications(notificationRepository);
final getUnreadNotifications = usecases.GetUnreadNotifications(notificationRepository);
final markNotificationAsRead = usecases.MarkNotificationAsRead(notificationRepository);
final markAllNotificationsAsRead = usecases.MarkAllNotificationsAsRead(notificationRepository);
final deleteNotification = usecases.DeleteNotification(notificationRepository);
final clearAllNotifications = usecases.ClearAllNotifications(notificationRepository);
final createNotification = usecases.CreateNotification(notificationRepository);
final syncNotifications = usecases.SyncNotifications(notificationRepository);

// Initialize BLoC
final notificationBloc = NotificationBloc(
  getNotificationsUseCase: getNotifications,
  getUnreadNotificationsUseCase: getUnreadNotifications,
  markNotificationAsReadUseCase: markNotificationAsRead,
  markAllNotificationsAsReadUseCase: markAllNotificationsAsRead,
  deleteNotificationUseCase: deleteNotification,
  clearAllNotificationsUseCase: clearAllNotifications,
  createNotificationUseCase: createNotification,
  syncNotificationsUseCase: syncNotifications,
  userId: currentUserId, // Pass current user ID
);
```

### 2. Provide BLoC to Widget Tree

```dart
BlocProvider(
  create: (context) => notificationBloc..add(LoadNotifications()),
  child: NotificationPage(),
)
```

### 3. Initialize Database on App Start

In `main.dart` or `_initializeCoreServices()`:

```dart
// Initialize notification database
final notificationLocalDataSource = NotificationLocalDataSourceImpl();
await notificationLocalDataSource.database; // This initializes the database
```

## 📋 Usage Examples

### Load Notifications
```dart
context.read<NotificationBloc>().add(LoadNotifications());
```

### Mark as Read
```dart
context.read<NotificationBloc>().add(MarkAsRead(notificationId));
```

### Mark All as Read
```dart
context.read<NotificationBloc>().add(MarkAllAsRead());
```

### Delete Notification
```dart
context.read<NotificationBloc>().add(DeleteNotification(notificationId));
```

### Clear All Notifications
```dart
context.read<NotificationBloc>().add(ClearAllNotifications());
```

### Refresh (Sync from Server)
```dart
context.read<NotificationBloc>().add(RefreshNotifications());
```

### Create Notification
```dart
context.read<NotificationBloc>().add(
  CreateNotification(
    title: 'Medicine Reminder',
    body: 'Time to take your medication',
    type: NotificationType.medicineReminder,
    data: {'reminder_id': '123'},
  ),
);
```

## 🔄 Offline-First Flow

### Online:
```
User Action → BLoC → UseCase → Repository
                                    ↓
                    [Fetch from Local] → Update UI
                                    ↓
                    [Sync from Server] → Update Local → Update UI
```

### Offline:
```
User Action → BLoC → UseCase → Repository
                                    ↓
                    [Fetch from Local] → Update UI
                    [Changes queued for later sync]
```

## 🗄️ Database Schema

```sql
CREATE TABLE notifications (
  id TEXT PRIMARY KEY,
  user_id INTEGER NOT NULL,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  type TEXT NOT NULL,
  created_at TEXT NOT NULL,
  is_read INTEGER NOT NULL DEFAULT 0,
  read_at TEXT,
  data TEXT
)

CREATE INDEX idx_user_id ON notifications(user_id)
CREATE INDEX idx_is_read ON notifications(is_read)
```

## 🌐 API Endpoints

### GET `/notifications/user/:userId`
Fetch all notifications for a user

### GET `/notifications/user/:userId/unread`
Fetch unread notifications for a user

### PUT `/notifications/:notificationId/read`
Mark notification as read

### PUT `/notifications/user/:userId/read-all`
Mark all notifications as read

### DELETE `/notifications/:notificationId`
Delete notification

### DELETE `/notifications/user/:userId`
Clear all notifications

### POST `/notifications`
Create new notification

## 🎨 Notification Types

```dart
enum NotificationType {
  medicineReminderDue,      // Medicine due now
  medicineReminder,         // Upcoming medicine reminder
  appointmentReminder,      // Appointment reminder
  deviceAlert,              // Device-related alerts
  parentalAlert,            // Parental control alerts
  general,                  // General notifications
  fcmTest,                  // Test notifications
  unknown,                  // Unknown type
}
```

## ✨ Key Features

1. **Offline-First**: Works seamlessly without internet
2. **Auto-Sync**: Automatically syncs when online
3. **SQLite Cache**: Fast local storage
4. **Clean Architecture**: Separation of concerns
5. **SOLID Principles**: Maintainable and testable code
6. **Type-Safe**: Full type safety with Dart
7. **Batch Operations**: Efficient bulk operations
8. **Error Handling**: Graceful error handling with fallbacks

## 🧪 Testing

The clean architecture makes testing easy:

```dart
// Test use cases
final mockRepository = MockNotificationRepository();
final useCase = GetNotifications(mockRepository);

// Test repository
final mockLocalDataSource = MockNotificationLocalDataSource();
final mockRemoteDataSource = MockNotificationRemoteDataSource();
final repository = NotificationRepositoryImpl(
  localDataSource: mockLocalDataSource,
  remoteDataSource: mockRemoteDataSource,
);

// Test BLoC
final mockUseCase = MockGetNotifications();
final bloc = NotificationBloc(
  getNotificationsUseCase: mockUseCase,
  // ... other dependencies
);
```

## 📊 Benefits

✅ **Testability**: Each layer can be tested independently  
✅ **Maintainability**: Changes in one layer don't affect others  
✅ **Scalability**: Easy to add new features  
✅ **Reusability**: Use cases can be reused across different UIs  
✅ **Flexibility**: Easy to swap implementations (e.g., different databases)  
✅ **Offline Support**: Works without internet connection  
✅ **Performance**: Local caching for fast access  

## 🎉 Complete!

Your notification feature now has:
- ✅ Clean architecture with clear separation of concerns
- ✅ Offline-first with automatic synchronization
- ✅ Local SQLite database for caching
- ✅ Remote API integration
- ✅ Full CRUD operations
- ✅ BLoC state management
- ✅ Type-safe notification types
- ✅ Comprehensive error handling

The architecture is production-ready and follows industry best practices!
