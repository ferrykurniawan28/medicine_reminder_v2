part of 'medical_record_bloc.dart';

abstract class MedicalRecordState extends Equatable {
  const MedicalRecordState();

  @override
  List<Object?> get props => [];
}

class MedicalRecordInitial extends MedicalRecordState {}

class MedicalRecordLoading extends MedicalRecordState {}

class MedicalRecordsLoaded extends MedicalRecordState {
  final List<MedicalRecord> records;

  const MedicalRecordsLoaded(this.records);

  @override
  List<Object> get props => [records];
}

class MedicalRecordLoaded extends MedicalRecordState {
  final MedicalRecord record;

  const MedicalRecordLoaded(this.record);

  @override
  List<Object> get props => [record];
}

class ReminderRecordsLoaded extends MedicalRecordState {
  final List<ReminderRecord> records;

  const ReminderRecordsLoaded(this.records);

  @override
  List<Object> get props => [records];
}

class AppointmentRecordsLoaded extends MedicalRecordState {
  final List<AppointmentRecord> records;

  const AppointmentRecordsLoaded(this.records);

  @override
  List<Object> get props => [records];
}

class MedicalRecordSuccess extends MedicalRecordState {
  final String message;

  const MedicalRecordSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class MedicalRecordError extends MedicalRecordState {
  final String message;

  const MedicalRecordError(this.message);

  @override
  List<Object> get props => [message];
}
