import 'package:medicine_reminder/features/user/domain/entities/user.dart';
import '../../domain/entities/appointment.dart';

class AppointmentModel extends Appointment {
  final int isSynced;
  final int isDeleted;
  final int isUpdated;

  const AppointmentModel({
    super.id,
    required super.userCreated,
    required super.userAssigned,
    required super.doctor,
    super.note,
    required super.time,
    this.isSynced = 0,
    this.isDeleted = 0,
    this.isUpdated = 0,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    // Handle both API (Map) and DB (int) for user fields
    User parseUser(dynamic value) {
      if (value is Map<String, dynamic>) {
        return User.fromJson(value);
      } else if (value is int) {
        return User(userId: value);
      } else {
        throw Exception('Invalid user value: $value');
      }
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
      isUpdated: json['is_updated'] is int
          ? json['is_updated'] ?? 0
          : int.tryParse(json['is_updated']?.toString() ?? '0') ?? 0,
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
        'is_updated': isUpdated,
      };
}
