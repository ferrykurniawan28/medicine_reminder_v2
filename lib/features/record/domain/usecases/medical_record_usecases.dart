import '../entities/medical_record.dart';
import '../repositories/medical_record_repository.dart';

class GetMedicalRecords {
  final MedicalRecordRepository repository;

  GetMedicalRecords(this.repository);

  Future<List<MedicalRecord>> call({
    int? userId,
    String? type,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    int? page,
    int? limit,
  }) {
    return repository.getMedicalRecords(
      userId: userId,
      type: type,
      status: status,
      startDate: startDate,
      endDate: endDate,
      page: page,
      limit: limit,
    );
  }
}

class GetMedicalRecord {
  final MedicalRecordRepository repository;

  GetMedicalRecord(this.repository);

  Future<MedicalRecord?> call(int id) {
    return repository.getMedicalRecord(id);
  }
}

class GetReminderRecords {
  final MedicalRecordRepository repository;

  GetReminderRecords(this.repository);

  Future<List<ReminderRecord>> call({
    int? userId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return repository.getReminderRecords(
      userId: userId,
      status: status,
      startDate: startDate,
      endDate: endDate,
    );
  }
}

class GetAppointmentRecords {
  final MedicalRecordRepository repository;

  GetAppointmentRecords(this.repository);

  Future<List<AppointmentRecord>> call({
    int? userId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return repository.getAppointmentRecords(
      userId: userId,
      status: status,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
