import '../models/medical_record_model.dart';

abstract class MedicalRecordLocalDataSource {
  Future<List<MedicalRecordModel>> getMedicalRecords({
    int? userId,
    String? type,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<MedicalRecordModel?> getMedicalRecord(int id);

  Future<void> addMedicalRecord(MedicalRecordModel record);

  Future<void> updateMedicalRecord(MedicalRecordModel record);

  Future<void> deleteMedicalRecord(int id);

  Future<void> deleteAllMedicalRecords();
}
