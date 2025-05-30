import 'package:medicine_reminder/features/user/domain/entities/user.dart';
import '../../domain/entities/appointment.dart';

class AppointmentModel extends Appointment {
  const AppointmentModel({
    super.id,
    required super.userCreated,
    required super.userAssigned,
    required super.doctor,
    super.note,
    required super.time,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    // Handle both API (Map) and DB (int) for user fields
    User parseUser(dynamic value) {
      if (value is Map<String, dynamic>) {
        return User.fromJson(value);
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
      };
}
