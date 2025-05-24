import 'package:medicine_reminder/features/doctor/data/models/doctor_model.dart';
import 'package:medicine_reminder/models/models.dart';

import '../../domain/entities/appointment.dart';

class AppointmentModel extends Appointment {
  const AppointmentModel({
    super.id,
    required super.user,
    required DoctorModel super.doctor,
    super.note,
    required super.time,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      AppointmentModel(
        id: json['id'] == null
            ? null
            : (json['id'] is int
                ? json['id']
                : int.tryParse(json['id'].toString())),
        user: User(
          userId: json['user'] is Map
              ? (json['user']['userId'] ?? 0)
              : (json['userId'] ?? 0),
          userName: json['user'] is Map
              ? (json['user']['userName'] ?? '')
              : (json['userName'] ?? ''),
          role: json['user'] is Map && json['user']['role'] != null
              ? UserRole.values[json['user']['role']]
              : (json['userRole'] != null
                  ? UserRole.values[json['userRole']]
                  : null),
        ),
        doctor: json['doctor'] is Map
            ? DoctorModel.fromJson(json['doctor'])
            : DoctorModel(
                id: json['doctorId'],
                name: json['doctorName'] ?? '',
                speciality: json['doctorSpeciality'],
              ),
        note: json['note'],
        time: DateTime.parse(json['time']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user.toJson(),
        'doctor': doctor.toJson(),
        'note': note,
        'time': time.toIso8601String(),
      };
}
