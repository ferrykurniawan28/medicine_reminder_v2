import 'package:medicine_reminder/core/constant/url.dart';

import '../../../../core/network/network_service.dart';
import '../models/medical_record_model.dart';
import 'medical_record_remote_datasource.dart';

class MedicalRecordRemoteDataSourceImpl
    implements MedicalRecordRemoteDataSource {
  final NetworkService networkService;

  MedicalRecordRemoteDataSourceImpl(this.networkService);

  @override
  Future<List<MedicalRecordModel>> getMedicalRecords({
    int? userId,
    String? type,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    int? page,
    int? limit,
  }) async {
    try {
      // Build query parameters for pagination and filtering
      // The server expects: /medical-record/:user_id?page=1&limit=50&type=reminder&date_from=...&date_to=...
      String url = "$medicalRecordURL/$userId";
      List<String> queryParts = [];

      if (page != null) queryParts.add('page=$page');
      if (limit != null) queryParts.add('limit=$limit');
      if (type != null) queryParts.add('type=$type');
      if (status != null) queryParts.add('status=$status');
      if (startDate != null)
        queryParts.add('date_from=${startDate.toIso8601String()}');
      if (endDate != null)
        queryParts.add('date_to=${endDate.toIso8601String()}');

      if (queryParts.isNotEmpty) {
        url += '?${queryParts.join('&')}';
      }

      print('Fetching medical records from: $url');
      final response = await networkService.get(url);

      print('Medical Records Response: $response');
      print(response.data);

      if (response.isSuccess && response.data != null) {
        final List<dynamic> recordsJson;

        // Handle the new pagination response structure
        if (response.data is Map<String, dynamic>) {
          final responseMap = response.data as Map<String, dynamic>;

          // Check if it has the 'records' field (new pagination structure)
          if (responseMap['records'] != null) {
            recordsJson = responseMap['records'] as List<dynamic>;
            print('Found ${recordsJson.length} records in paginated response');
            print(
                'Pagination info - Limit: ${responseMap['limit']}, Page: ${responseMap['page']}');
          }
          // Check if it has the 'data' field (old structure)
          else if (responseMap['data'] != null) {
            recordsJson = responseMap['data'] as List<dynamic>;
          } else {
            recordsJson = [];
          }
        }
        // Handle direct list response
        else if (response.data is List) {
          recordsJson = response.data as List<dynamic>;
        } else {
          recordsJson = [];
        }

        print('Processing ${recordsJson.length} medical records from server');

        return recordsJson
            .map((json) =>
                MedicalRecordModel.fromJson(json as Map<String, dynamic>))
            .cast<MedicalRecordModel>()
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching medical records: $e');
      throw Exception('Failed to fetch medical records: $e');
    }
  }

  @override
  Future<MedicalRecordModel?> getMedicalRecord(int id) async {
    try {
      final response = await networkService.get('/medical-records/$id');

      print('Medical Record Response: $response');

      if (response.isSuccess && response.data != null) {
        dynamic recordData = response.data;

        // Handle potential nested data structure
        if (recordData is Map<String, dynamic>) {
          // Check if it has nested 'data' field
          if (recordData['data'] != null) {
            recordData = recordData['data'];
          }
          // Check if it has 'record' field (in case single record has different structure)
          else if (recordData['record'] != null) {
            recordData = recordData['record'];
          }
        }

        return MedicalRecordModel.fromJson(recordData as Map<String, dynamic>)
            as MedicalRecordModel;
      }
      return null;
    } catch (e) {
      print('Error fetching medical record: $e');
      throw Exception('Failed to fetch medical record: $e');
    }
  }

  @override
  Future<void> addMedicalRecord(MedicalRecordModel record) async {
    try {
      final response = await networkService.post(
        '/medical-records',
        body: record.toJson(),
      );
      print('Add Medical Record Response: $response');
    } catch (e) {
      print('Error adding medical record: $e');
      throw Exception('Failed to add medical record: $e');
    }
  }

  @override
  Future<void> updateMedicalRecord(MedicalRecordModel record) async {
    try {
      final int recordId;
      if (record is ReminderRecordModel) {
        recordId = record.id;
      } else if (record is AppointmentRecordModel) {
        recordId = record.id;
      } else {
        throw Exception('Unknown record type');
      }

      final response = await networkService.put(
        '/medical-records/$recordId',
        body: record.toJson(),
      );
      print('Update Medical Record Response: $response');
    } catch (e) {
      print('Error updating medical record: $e');
      throw Exception('Failed to update medical record: $e');
    }
  }

  @override
  Future<void> deleteMedicalRecord(int id) async {
    try {
      final response = await networkService.delete('/medical-records/$id');
      print('Delete Medical Record Response: $response');
    } catch (e) {
      print('Error deleting medical record: $e');
      throw Exception('Failed to delete medical record: $e');
    }
  }
}
