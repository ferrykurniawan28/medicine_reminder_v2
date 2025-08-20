part of 'medical_record_bloc.dart';

abstract class MedicalRecordEvent extends Equatable {
  const MedicalRecordEvent();

  @override
  List<Object?> get props => [];
}

class LoadMedicalRecords extends MedicalRecordEvent {
  final int? userId;
  final String? type;
  final String? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? page;
  final int? limit;

  const LoadMedicalRecords({
    this.userId,
    this.type,
    this.status,
    this.startDate,
    this.endDate,
    this.page,
    this.limit,
  });

  @override
  List<Object?> get props =>
      [userId, type, status, startDate, endDate, page, limit];
}

class LoadMedicalRecord extends MedicalRecordEvent {
  final int id;

  const LoadMedicalRecord(this.id);

  @override
  List<Object> get props => [id];
}

class LoadReminderRecords extends MedicalRecordEvent {
  final int? userId;
  final String? status;
  final DateTime? startDate;
  final DateTime? endDate;

  const LoadReminderRecords({
    this.userId,
    this.status,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [userId, status, startDate, endDate];
}

class LoadAppointmentRecords extends MedicalRecordEvent {
  final int? userId;
  final String? status;
  final DateTime? startDate;
  final DateTime? endDate;

  const LoadAppointmentRecords({
    this.userId,
    this.status,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [userId, status, startDate, endDate];
}

class CreateMedicalRecord extends MedicalRecordEvent {
  final MedicalRecord record;

  const CreateMedicalRecord(this.record);

  @override
  List<Object> get props => [record];
}

class EditMedicalRecord extends MedicalRecordEvent {
  final MedicalRecord record;

  const EditMedicalRecord(this.record);

  @override
  List<Object> get props => [record];
}

class RemoveMedicalRecord extends MedicalRecordEvent {
  final int id;

  const RemoveMedicalRecord(this.id);

  @override
  List<Object> get props => [id];
}

class RefreshMedicalRecords extends MedicalRecordEvent {
  final int? userId;
  final String? type;
  final String? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? page;
  final int? limit;

  const RefreshMedicalRecords({
    this.userId,
    this.type,
    this.status,
    this.startDate,
    this.endDate,
    this.page,
    this.limit,
  });

  @override
  List<Object?> get props =>
      [userId, type, status, startDate, endDate, page, limit];
}
