part of 'models.dart';

class Appointment {
  final int? id;
  final User user;
  final Group? group;
  final Doctor doctor;
  final String? note;
  final DateTime time;

  Appointment({
    this.id,
    required this.user,
    this.group,
    required this.doctor,
    this.note,
    required this.time,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      user: User.fromJson(json['user']),
      group: json['group'] != null ? Group.fromJson(json['group']) : null,
      doctor: json['doctor'],
      note: json['note'],
      time: DateTime.parse(json['time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'group': group?.toJson(),
      'doctor': doctor,
      'note': note,
      'time': time.toIso8601String(),
    };
  }

  Appointment copyWith({
    int? id,
    User? user,
    Group? group,
    Doctor? doctor,
    String? note,
    DateTime? time,
  }) {
    return Appointment(
      id: id ?? this.id,
      user: user ?? this.user,
      group: group,
      doctor: doctor ?? this.doctor,
      note: note,
      time: time ?? this.time,
    );
  }
}

List<Appointment> dummyAppointment = [
  Appointment(
    id: 1,
    user: User(userId: 1, userName: 'User 1', role: UserRole.admin),
    group: Group(
      id: 1,
      name: 'Group 1',
      creatorId: 1,
      users: [
        User(userId: 1, userName: 'User 1', role: UserRole.admin),
        User(userId: 2, userName: 'User 2', role: UserRole.member),
      ],
    ),
    doctor: Doctor(name: 'Doctor 1'),
    note: 'Note 1',
    time: DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 9, 0),
  ),
  Appointment(
    id: 2,
    user: User(userId: 2, userName: 'User 2', role: UserRole.member),
    doctor: Doctor(name: 'Doctor 2'),
    time: DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 9, 0),
  ),
];
