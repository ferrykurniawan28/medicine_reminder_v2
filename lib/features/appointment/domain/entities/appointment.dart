import 'package:medicine_reminder/features/user/domain/entities/user.dart';

class Appointment {
  final int? id;
  final User userCreated;
  final User userAssigned;
  final String doctor; // Now a String
  final String? note;
  final DateTime time;

  const Appointment({
    this.id,
    required this.userCreated,
    required this.userAssigned,
    required this.doctor,
    this.note,
    required this.time,
  });

  Appointment copyWith({
    int? id,
    User? userCreated,
    User? userAssigned,
    String? doctor,
    String? note,
    DateTime? time,
  }) {
    return Appointment(
      id: id ?? this.id,
      userCreated: userCreated ?? this.userCreated,
      userAssigned: userAssigned ?? this.userAssigned,
      doctor: doctor ?? this.doctor,
      note: note ?? this.note,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_by': userCreated.userId,
      'assigned_to': userAssigned.userId,
      'doctor': doctor,
      'note': note,
      'time': time.toIso8601String(),
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      userCreated: json['created_by'] is Map
          ? User.fromJson(json['created_by'])
          : User(userId: json['created_by'] ?? 0, userName: '', email: ''),
      userAssigned: json['assigned_to'] is Map
          ? User.fromJson(json['assigned_to'])
          : User(userId: json['assigned_to'] ?? 0, userName: '', email: ''),
      doctor: json['doctor'] ?? '',
      note: json['note'],
      time: json['time'] != null
          ? (json['time'] is DateTime
              ? json['time']
              : DateTime.tryParse(json['time'].toString()) ?? DateTime.now())
          : DateTime.now(),
    );
  }
}
