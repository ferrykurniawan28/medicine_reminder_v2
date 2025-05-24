import 'package:medicine_reminder/models/models.dart';
import 'package:medicine_reminder/features/doctor/domain/entities/doctor.dart';

class Appointment {
  final int? id;
  final User user;
  final Doctor doctor;
  final String? note;
  final DateTime time;

  const Appointment({
    this.id,
    required this.user,
    required this.doctor,
    this.note,
    required this.time,
  });

  Appointment copyWith({
    int? id,
    User? user,
    Doctor? doctor,
    String? note,
    DateTime? time,
  }) {
    return Appointment(
      id: id ?? this.id,
      user: user ?? this.user,
      doctor: doctor ?? this.doctor,
      note: note ?? this.note,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'doctor': doctor.toJson(),
      'note': note,
      'time': time.toIso8601String(),
    };
  }
}
