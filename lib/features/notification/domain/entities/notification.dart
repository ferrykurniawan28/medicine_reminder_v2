import 'package:medicine_reminder/features/notification/data/models/notification_model.dart';

/// Domain entity for notifications
class Notification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final DateTime? readAt;
  final int? userId;
  final Map<String, dynamic>? data;

  const Notification({
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

  Notification copyWith({
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
    return Notification(
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
}
