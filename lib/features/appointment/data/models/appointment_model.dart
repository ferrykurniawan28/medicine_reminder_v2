import 'package:medicine_reminder/features/user/domain/entities/user.dart';
import '../../domain/entities/appointment.dart';

class AppointmentModel extends Appointment {
  final int isSynced;
  final int isDeleted;

  const AppointmentModel({
    super.id,
    required super.userCreated,
    required super.userAssigned,
    required super.doctor,
    super.note,
    required super.time,
    this.isSynced = 0,
    this.isDeleted = 0,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    // Handle both API (Map) and DB (int) for user fields
    User parseUser(dynamic value) {
      if (value is Map<String, dynamic>) {
        // Accepts API keys: id, username, email
        return User(
          userId: value['id'] is int
              ? value['id']
              : int.tryParse(value['id']?.toString() ?? '0') ?? 0,
          userName: value['username'] ?? '',
          email: value['email'] ?? '',
        );
      } else if (value is int) {
        return User(userId: value, userName: '', email: '');
      } else if (value != null && value.toString().isNotEmpty) {
        // Try parsing string/int
        final id = int.tryParse(value.toString());
        if (id != null) return User(userId: id, userName: '', email: '');
      }
      return User(userId: 0, userName: '', email: ''); // fallback
    }

    return AppointmentModel(
      id: json['id'] == null
          ? null
          : (json['id'] is int
              ? json['id']
              : int.tryParse(json['id'].toString())),
      userCreated: parseUser(json['created_by']),
      userAssigned: parseUser(json['assigned_to']),
      doctor: json['doctor'] ?? '',
      note: json['notes'],
      time: json['dates'] != null
          ? DateTime.parse(json['dates'])
          : DateTime.now(),
      isSynced: json['is_synced'] is int
          ? json['is_synced'] ?? 0
          : int.tryParse(json['is_synced']?.toString() ?? '0') ?? 0,
      isDeleted: json['is_deleted'] is int
          ? json['is_deleted'] ?? 0
          : int.tryParse(json['is_deleted']?.toString() ?? '0') ?? 0,
    );
  }

  static AppointmentModel fromDomain(Appointment appointment) {
    return AppointmentModel(
      id: appointment.id,
      userCreated: appointment.userCreated,
      userAssigned: appointment.userAssigned,
      doctor: appointment.doctor,
      note: appointment.note,
      time: appointment.time,
      isSynced: 1, // Default value for synced status
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'created_by': userCreated.userId,
        'assigned_to': userAssigned.userId,
        'doctor': doctor,
        'notes': note,
        'dates': time.toIso8601String(),
        'is_synced': isSynced,
        'is_deleted': isDeleted,
      };
}
