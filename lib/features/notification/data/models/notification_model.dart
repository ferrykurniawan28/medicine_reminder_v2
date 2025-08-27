import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic>? data;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.data,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    DateTime? createdAt,
    bool? isRead,
    Map<String, dynamic>? data,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
    );
  }

  // Convert from JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => NotificationType.general,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      isRead: json['is_read'] as bool? ?? false,
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type.toString().split('.').last,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
      'data': data,
    };
  }

  @override
  List<Object?> get props => [id, title, body, type, createdAt, isRead, data];
}

enum NotificationType {
  medicineReminder,
  appointmentReminder,
  deviceAlert,
  parentalAlert,
  general,
  fcmTest,
}

extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
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
    }
  }

  String get description {
    switch (this) {
      case NotificationType.medicineReminder:
        return 'Reminders for taking medications';
      case NotificationType.appointmentReminder:
        return 'Upcoming medical appointments';
      case NotificationType.deviceAlert:
        return 'Alerts from your medicine devices';
      case NotificationType.parentalAlert:
        return 'Notifications about children\'s medications';
      case NotificationType.fcmTest:
        return 'Test notifications for debugging';
      case NotificationType.general:
        return 'General app notifications';
    }
  }
}
