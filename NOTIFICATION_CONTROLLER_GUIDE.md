# Notification Controller Usage Guide

## Overview

The `NotificationController` manages notification scheduling for medicine reminders with intelligent online/offline handling:

- **Online Mode**: Server sends notifications via Firebase Cloud Messaging (FCM)
- **Offline Mode**: Local notifications are scheduled automatically

## Architecture

### Flow Diagram
```
[Reminder Created/Updated]
         |
         v
[Check Connectivity]
         |
    +----+----+
    |         |
  Online    Offline
    |         |
    v         v
[FCM Sends]  [Local Scheduled]
```

## How It Works

### 1. **Automatic Connectivity Detection**
The controller listens to connectivity changes and automatically switches between online and offline modes.

```dart
// The controller automatically detects connectivity
NotificationController().initialize();
```

### 2. **Smart Notification Scheduling**

#### When Online:
- No local notifications are scheduled
- Server handles all notifications via FCM
- Notifications are sent from the backend at the right time

#### When Offline:
- Local notifications are automatically scheduled
- Uses `flutter_local_notifications` with timezone support
- Handles different reminder types (daily, weekly, interval, as-needed)

### 3. **Integration with Reminder Repository**

The `NotificationController` is integrated directly into `ReminderRepositoryImpl`:

```dart
// When getting reminders
Future<List<Reminder>> getReminders(int userId) async {
  // ... fetch reminders ...
  
  // If offline, schedule local notifications
  if (isOnline == null || !isOnline!()) {
    await _scheduleLocalNotifications(local);
  }
  
  return reminders;
}
```

## Features

### ✅ Automatic Scheduling

**Add Reminder:**
```dart
// Automatically schedules notification if active
await reminderRepository.addReminder(reminder);
```

**Update Reminder:**
```dart
// Cancels old notifications and reschedules
await reminderRepository.updateReminder(reminder);
```

**Delete Reminder:**
```dart
// Automatically cancels all notifications
await reminderRepository.deleteReminder(reminderId);
```

**Toggle Status:**
```dart
// Activates/deactivates notifications based on isActive
await reminderRepository.updateReminderStatus(reminder);
```

### ✅ Reminder Type Support

1. **Daily Reminders**
   - Schedules notifications for specified times every day
   - If time has passed today, schedules for tomorrow

2. **Weekly Reminders**
   - Schedules for specific days of the week
   - Multiple times per day supported

3. **Interval Reminders**
   - Schedules based on interval settings
   - Repeats at specified intervals

4. **As-Needed Reminders**
   - Not automatically scheduled
   - Can be triggered manually

## Manual Control (Optional)

### Schedule Specific Reminder
```dart
final controller = NotificationController();
await controller.scheduleReminderNotifications(reminder);
```

### Cancel Specific Reminder
```dart
await controller.cancelReminderNotifications(reminderId);
```

### Cancel All Notifications
```dart
await controller.cancelAllNotifications();
```

### Show Immediate Notification
```dart
await controller.showImmediateNotification(
  id: 1,
  title: 'Test Notification',
  body: 'This is a test',
  payload: 'test_payload',
);
```

### Reschedule All Reminders
```dart
// Useful when coming back online or after bulk changes
await controller.rescheduleAllReminders(reminderList);
```

## Setup Requirements

### 1. Dependencies
```yaml
dependencies:
  flutter_local_notifications: ^19.5.0
  timezone: ^0.10.1
  connectivity_plus: ^6.1.4
  firebase_messaging: ^16.0.0
```

### 2. Initialization in main.dart
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize timezone database
  tz.initializeTimeZones();
  
  // Initialize Firebase
  await Firebase.initializeApp(...);
  
  // Initialize services
  await ConnectivityService().initialize();
  await FCMService().initialize();
  await NotificationController().initialize();
  
  runApp(MyApp());
}
```

### 3. Android Configuration

**AndroidManifest.xml:**
```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

**For Android 12+:**
- Exact alarm permission is required for precise notification scheduling
- Users may need to grant this permission in system settings

### 4. iOS Configuration

**AppDelegate.swift:**
```swift
if #available(iOS 10.0, *) {
  UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
}
```

## Notification Channels

### Android Channels Created:
1. **reminder_channel** - Medicine Reminders
   - High importance
   - Sound and vibration enabled

2. **appointment_channel** - Appointments
   - High importance
   - Sound and vibration enabled

## Notification ID Generation

Notification IDs are generated to avoid conflicts:
```dart
int notificationId = (reminderId * 1000) + timeIndex
```

Example:
- Reminder ID 5, Time slot 0 → Notification ID: 5000
- Reminder ID 5, Time slot 1 → Notification ID: 5001

## Best Practices

### ✅ DO:
- Let the repository handle notification scheduling automatically
- Keep reminders in sync between server and local
- Test notification permissions on both Android and iOS
- Handle notification permission requests gracefully

### ❌ DON'T:
- Manually schedule notifications if already using the repository
- Forget to cancel notifications when deleting reminders
- Schedule too many notifications (Android has limits)
- Ignore timezone handling

## Testing

### Test Online Mode:
1. Enable WiFi/Mobile data
2. Create/update a reminder
3. Check that no local notifications are scheduled
4. Verify FCM receives notifications from server

### Test Offline Mode:
1. Disable WiFi/Mobile data
2. Create/update a reminder
3. Check local notifications are scheduled
4. Use notification testing tools to verify

### Test Transition:
1. Start offline → create reminders
2. Go online → local notifications remain
3. Go offline again → new reminders schedule locally

## Troubleshooting

### Notifications Not Appearing:

**Check Permissions:**
```dart
final status = await Permission.notification.status;
if (!status.isGranted) {
  await Permission.notification.request();
}
```

**Check Scheduled Notifications:**
```dart
final pendingNotifications = await NotificationController()
    ._localNotifications
    .pendingNotificationRequests();
print('Pending: ${pendingNotifications.length}');
```

**Check Timezone:**
```dart
print('Local timezone: ${tz.local}');
```

### Android 12+ Issues:
- Grant SCHEDULE_EXACT_ALARM permission in system settings
- Check if battery optimization is affecting notifications
- Verify Do Not Disturb settings

### iOS Issues:
- Check notification permissions in system settings
- Verify AppDelegate configuration
- Test with app in different states (foreground/background/terminated)

## Example Usage

```dart
// Example: Creating a daily reminder with automatic notifications
final reminder = Reminder(
  medicineName: 'Aspirin',
  dosage: [1],
  type: ReminderType.daily,
  times: [Time(hour: 9, minute: 0), Time(hour: 21, minute: 0)],
  isActive: true,
);

// This automatically handles notifications based on connectivity
final createdReminder = await reminderRepository.addReminder(reminder);

// When offline: 2 local notifications scheduled (9 AM and 9 PM daily)
// When online: Server sends FCM notifications at 9 AM and 9 PM

// Later, update the reminder
reminder.times = [Time(hour: 10, minute: 0)]; // Change to 10 AM
await reminderRepository.updateReminder(reminder);

// Old notifications cancelled, new ones scheduled if offline

// Deactivate reminder
reminder.isActive = false;
await reminderRepository.updateReminderStatus(reminder);

// All notifications cancelled
```

## Summary

The `NotificationController` provides a seamless notification experience:
- ✅ Automatic online/offline detection
- ✅ Integrated with repository layer
- ✅ Supports all reminder types
- ✅ Handles scheduling, updates, and cancellation
- ✅ No manual intervention needed in most cases
- ✅ Server-first when online, local fallback when offline

Your app now has a robust notification system that works reliably regardless of connectivity! 🎉
