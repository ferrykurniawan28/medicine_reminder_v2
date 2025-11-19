import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final DateTime? readAt;
  final int? userId;
  final Map<String, dynamic>? data;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.readAt,
    this.userId,
    this.data,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? createdAt,
    bool? isRead,
    DateTime? readAt,
    int? userId,
    Map<String, dynamic>? data,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      userId: userId ?? this.userId,
      data: data ?? this.data,
    );
  }

  // Convert from JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'].toString(),
      title: json['title'] as String,
      message: json['message'] as String,
      type: NotificationTypeExtension.fromString(json['type']),
      createdAt: DateTime.parse(json['created_at']),
      isRead: json['is_read'] as bool? ?? false,
      readAt: json['read_at'] != null &&
              json['read_at'] != "" &&
              json['read_at'] != "0001-01-01T00:00:00Z"
          ? DateTime.parse(json['read_at'])
          : null,
      userId: json['user_id'] as int?,
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.key,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
      'read_at': readAt?.toIso8601String(),
      'user_id': userId,
      'data': data,
    };
  }

  @override
  List<Object?> get props =>
      [id, title, message, type, createdAt, isRead, readAt, userId, data];
}

// Updated enum to match backend values
enum NotificationType {
  medicineReminderDue,
  medicineReminder,
  appointmentReminder,
  deviceAlert,
  parentalAlert,
  general,
  fcmTest,
  unknown,
}

extension NotificationTypeExtension on NotificationType {
  /// Convert backend string → enum
  static NotificationType fromString(String? value) {
    switch (value) {
      case 'medicine_reminder_due':
        return NotificationType.medicineReminderDue;
      case 'medicine_reminder':
        return NotificationType.medicineReminder;
      case 'appointment':
      case 'appointment_reminder':
        return NotificationType.appointmentReminder;
      case 'device_alert':
        return NotificationType.deviceAlert;
      case 'parental_alert':
        return NotificationType.parentalAlert;
      case 'fcm_test':
        return NotificationType.fcmTest;
      case 'general':
        return NotificationType.general;
      default:
        return NotificationType.unknown;
    }
  }

  /// Convert enum → backend string
  String get key {
    switch (this) {
      case NotificationType.medicineReminderDue:
        return 'medicine_reminder_due';
      case NotificationType.medicineReminder:
        return 'medicine_reminder';
      case NotificationType.appointmentReminder:
        return 'appointment_reminder';
      case NotificationType.deviceAlert:
        return 'device_alert';
      case NotificationType.parentalAlert:
        return 'parental_alert';
      case NotificationType.fcmTest:
        return 'fcm_test';
      case NotificationType.general:
        return 'general';
      case NotificationType.unknown:
        return 'unknown';
    }
  }

  String get displayName {
    switch (this) {
      case NotificationType.medicineReminderDue:
        return 'Medicine Reminder Due';
      case NotificationType.medicineReminder:
        return 'Medicine Reminder';
      case NotificationType.appointmentReminder:
        return 'Appointment Reminder';
      case NotificationType.deviceAlert:
        return 'Device Alert';
      case NotificationType.parentalAlert:
        return 'Parental Alert';
      case NotificationType.fcmTest:
        return 'Test Notification';
      case NotificationType.general:
        return 'General';
      case NotificationType.unknown:
        return 'Unknown';
    }
  }

  String get description {
    switch (this) {
      case NotificationType.medicineReminderDue:
        return 'A medicine reminder that is currently due.';
      case NotificationType.medicineReminder:
        return 'Scheduled medication reminders.';
      case NotificationType.appointmentReminder:
        return 'Upcoming medical appointments.';
      case NotificationType.deviceAlert:
        return 'Alerts from connected medicine devices.';
      case NotificationType.parentalAlert:
        return 'Notifications related to children’s medications.';
      case NotificationType.fcmTest:
        return 'Test notifications for debugging.';
      case NotificationType.general:
        return 'General app notifications.';
      case NotificationType.unknown:
        return 'Unknown notification type.';
    }
  }
}
