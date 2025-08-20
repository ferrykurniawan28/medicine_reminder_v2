import '../models/medical_record_model.dart';

abstract class MedicalRecordRemoteDataSource {
  Future<List<MedicalRecordModel>> getMedicalRecords({
    int? userId,
    String? type,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    int? page,
    int? limit,
  });

  Future<MedicalRecordModel?> getMedicalRecord(int id);

  Future<void> addMedicalRecord(MedicalRecordModel record);

  Future<void> updateMedicalRecord(MedicalRecordModel record);

  Future<void> deleteMedicalRecord(int id);
}
