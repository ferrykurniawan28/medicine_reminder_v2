import '../../domain/entities/medical_record.dart';

abstract class MedicalRecordModel {
  static MedicalRecord fromJson(Map<String, dynamic> json) {
    final String type = json['type'] ?? '';

    switch (type) {
      case 'reminder':
        return ReminderRecordModel.fromJson(json);
      case 'appointment':
        return AppointmentRecordModel.fromJson(json);
      default:
        throw ArgumentError('Unknown medical record type: $type');
    }
  }

  Map<String, dynamic> toJson();
}

class ReminderRecordModel extends ReminderRecord implements MedicalRecordModel {
  const ReminderRecordModel({
    required super.id,
    required super.logTime,
    required super.status,
    super.notes,
    required super.assignedTo,
    required super.createdBy,
    required super.createdAt,
    required super.medicineName,
    required super.dosage,
    required super.time,
    required super.deviceId,
    required super.containerId,
  });

  factory ReminderRecordModel.fromJson(Map<String, dynamic> json) {
    return ReminderRecordModel(
      id: json['id'] ?? 0,
      logTime:
          DateTime.parse(json['log_time'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? '',
      notes: json['notes'],
      assignedTo: json['assigned_to'] ?? 0,
      createdBy: json['created_by'] ?? '',
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      medicineName: json['medicine_name'] ?? '',
      dosage: json['dosage'] ?? 0,
      time: json['time'] ?? '',
      deviceId: json['device_id'] ?? 0,
      containerId: json['container_id'] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'log_time': logTime.toIso8601String(),
      'status': status,
      'notes': notes,
      'assigned_to': assignedTo,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'medicine_name': medicineName,
      'dosage': dosage,
      'time': time,
      'device_id': deviceId,
      'container_id': containerId,
    };
  }

  factory ReminderRecordModel.fromEntity(ReminderRecord entity) {
    return ReminderRecordModel(
      id: entity.id,
      logTime: entity.logTime,
      status: entity.status,
      notes: entity.notes,
      assignedTo: entity.assignedTo,
      createdBy: entity.createdBy,
      createdAt: entity.createdAt,
      medicineName: entity.medicineName,
      dosage: entity.dosage,
      time: entity.time,
      deviceId: entity.deviceId,
      containerId: entity.containerId,
    );
  }
}

class AppointmentRecordModel extends AppointmentRecord
    implements MedicalRecordModel {
  const AppointmentRecordModel({
    required super.id,
    required super.logTime,
    required super.status,
    super.notes,
    required super.assignedTo,
    required super.createdBy,
    required super.createdAt,
    required super.doctor,
    required super.appointmentDate,
  });

  factory AppointmentRecordModel.fromJson(Map<String, dynamic> json) {
    return AppointmentRecordModel(
      id: json['id'] ?? 0,
      logTime:
          DateTime.parse(json['log_time'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? '',
      notes: json['notes'],
      assignedTo: json['assigned_to'] ?? 0,
      createdBy: json['created_by'] ?? '',
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      doctor: json['doctor'] ?? '',
      appointmentDate: DateTime.parse(
          json['appointment_date'] ?? DateTime.now().toIso8601String()),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'log_time': logTime.toIso8601String(),
      'status': status,
      'notes': notes,
      'assigned_to': assignedTo,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'doctor': doctor,
      'appointment_date': appointmentDate.toIso8601String(),
    };
  }

  factory AppointmentRecordModel.fromEntity(AppointmentRecord entity) {
    return AppointmentRecordModel(
      id: entity.id,
      logTime: entity.logTime,
      status: entity.status,
      notes: entity.notes,
      assignedTo: entity.assignedTo,
      createdBy: entity.createdBy,
      createdAt: entity.createdAt,
      doctor: entity.doctor,
      appointmentDate: entity.appointmentDate,
    );
  }
}
