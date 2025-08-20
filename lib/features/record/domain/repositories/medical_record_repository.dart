import '../entities/medical_record.dart';

abstract class MedicalRecordRepository {
  Future<List<MedicalRecord>> getMedicalRecords({
    int? userId,
    String? type,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    int? page,
    int? limit,
  });

  Future<MedicalRecord?> getMedicalRecord(int id);

  Future<List<ReminderRecord>> getReminderRecords({
    int? userId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<List<AppointmentRecord>> getAppointmentRecords({
    int? userId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<void> addMedicalRecord(MedicalRecord record);

  Future<void> updateMedicalRecord(MedicalRecord record);

  Future<void> deleteMedicalRecord(int id);
}
