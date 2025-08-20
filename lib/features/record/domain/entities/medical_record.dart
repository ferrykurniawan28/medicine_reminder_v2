import 'package:equatable/equatable.dart';

abstract class MedicalRecord extends Equatable {
  final int id;
  final String type;
  final DateTime logTime;
  final String status;
  final String? notes;
  final int assignedTo;
  final String createdBy;
  final DateTime createdAt;

  const MedicalRecord({
    required this.id,
    required this.type,
    required this.logTime,
    required this.status,
    this.notes,
    required this.assignedTo,
    required this.createdBy,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        logTime,
        status,
        notes,
        assignedTo,
        createdBy,
        createdAt,
      ];
}

class ReminderRecord extends MedicalRecord {
  final String medicineName;
  final int dosage;
  final String time;
  final int deviceId;
  final int containerId;

  const ReminderRecord({
    required super.id,
    required super.logTime,
    required super.status,
    super.notes,
    required super.assignedTo,
    required super.createdBy,
    required super.createdAt,
    required this.medicineName,
    required this.dosage,
    required this.time,
    required this.deviceId,
    required this.containerId,
  }) : super(type: 'reminder');

  @override
  List<Object?> get props => [
        ...super.props,
        medicineName,
        dosage,
        time,
        deviceId,
        containerId,
      ];
}

class AppointmentRecord extends MedicalRecord {
  final String doctor;
  final DateTime appointmentDate;

  const AppointmentRecord({
    required super.id,
    required super.logTime,
    required super.status,
    super.notes,
    required super.assignedTo,
    required super.createdBy,
    required super.createdAt,
    required this.doctor,
    required this.appointmentDate,
  }) : super(type: 'appointment');

  @override
  List<Object?> get props => [
        ...super.props,
        doctor,
        appointmentDate,
      ];
}
