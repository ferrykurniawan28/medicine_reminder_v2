import '../../domain/entities/medical_record.dart';
import '../../domain/repositories/medical_record_repository.dart';
import '../datasources/medical_record_local_datasource.dart';
import '../datasources/medical_record_remote_datasource.dart';
import '../models/medical_record_model.dart';

class MedicalRecordRepositoryImpl implements MedicalRecordRepository {
  final MedicalRecordLocalDataSource localDataSource;
  final MedicalRecordRemoteDataSource remoteDataSource;
  final bool Function()? isOnline;

  MedicalRecordRepositoryImpl(
    this.localDataSource, {
    required this.remoteDataSource,
    this.isOnline,
  });

  @override
  Future<List<MedicalRecord>> getMedicalRecords({
    int? userId,
    String? type,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    int? page,
    int? limit,
  }) async {
    try {
      // Try to get fresh data from remote first if online
      if (isOnline?.call() ?? false) {
        print('Fetching medical records from remote...');
        final remoteRecords = await remoteDataSource.getMedicalRecords(
          userId: userId,
          type: type,
          status: status,
          startDate: startDate,
          endDate: endDate,
          page: page,
          limit: limit,
        );

        // Save remote data to local storage for offline access
        for (final record in remoteRecords) {
          await localDataSource.addMedicalRecord(record);
        }

        print('Fetched ${remoteRecords.length} medical records from remote');
        return remoteRecords.cast<MedicalRecord>();
      }
    } catch (e) {
      print('Failed to fetch from remote, falling back to local: $e');
    }

    // Fall back to local data
    print('Fetching medical records from local cache...');
    final localRecords = await localDataSource.getMedicalRecords(
      userId: userId,
      type: type,
      status: status,
      startDate: startDate,
      endDate: endDate,
    );

    return localRecords.cast<MedicalRecord>();
  }

  @override
  Future<MedicalRecord?> getMedicalRecord(int id) async {
    try {
      // Try remote first if online
      if (isOnline?.call() ?? false) {
        final remoteRecord = await remoteDataSource.getMedicalRecord(id);
        if (remoteRecord != null) {
          // Save to local cache
          await localDataSource.addMedicalRecord(remoteRecord);
          return remoteRecord as MedicalRecord;
        }
      }
    } catch (e) {
      print('Failed to fetch record from remote, trying local: $e');
    }

    // Fall back to local
    final localRecord = await localDataSource.getMedicalRecord(id);
    return localRecord as MedicalRecord?;
  }

  @override
  Future<List<ReminderRecord>> getReminderRecords({
    int? userId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final records = await getMedicalRecords(
      userId: userId,
      type: 'reminder',
      status: status,
      startDate: startDate,
      endDate: endDate,
    );

    return records.whereType<ReminderRecord>().toList();
  }

  @override
  Future<List<AppointmentRecord>> getAppointmentRecords({
    int? userId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final records = await getMedicalRecords(
      userId: userId,
      type: 'appointment',
      status: status,
      startDate: startDate,
      endDate: endDate,
    );

    return records.whereType<AppointmentRecord>().toList();
  }

  @override
  Future<void> addMedicalRecord(MedicalRecord record) async {
    MedicalRecordModel model;

    if (record is ReminderRecord) {
      model = ReminderRecordModel.fromEntity(record);
    } else if (record is AppointmentRecord) {
      model = AppointmentRecordModel.fromEntity(record);
    } else {
      throw ArgumentError('Unsupported record type');
    }

    // Save locally first
    await localDataSource.addMedicalRecord(model);

    // Try to sync with remote if online
    if (isOnline?.call() ?? false) {
      try {
        await remoteDataSource.addMedicalRecord(model);
        print('Medical record synced with remote server');
      } catch (e) {
        print('Failed to sync with remote, will retry later: $e');
        // TODO: Add to sync queue for later retry
      }
    }
  }

  @override
  Future<void> updateMedicalRecord(MedicalRecord record) async {
    MedicalRecordModel model;

    if (record is ReminderRecord) {
      model = ReminderRecordModel.fromEntity(record);
    } else if (record is AppointmentRecord) {
      model = AppointmentRecordModel.fromEntity(record);
    } else {
      throw ArgumentError('Unsupported record type');
    }

    // Update locally first
    await localDataSource.updateMedicalRecord(model);

    // Try to sync with remote if online
    if (isOnline?.call() ?? false) {
      try {
        await remoteDataSource.updateMedicalRecord(model);
        print('Medical record updated on remote server');
      } catch (e) {
        print('Failed to sync update with remote, will retry later: $e');
        // TODO: Add to sync queue for later retry
      }
    }
  }

  @override
  Future<void> deleteMedicalRecord(int id) async {
    // Delete locally first
    await localDataSource.deleteMedicalRecord(id);

    // Try to sync with remote if online
    if (isOnline?.call() ?? false) {
      try {
        await remoteDataSource.deleteMedicalRecord(id);
        print('Medical record deleted from remote server');
      } catch (e) {
        print('Failed to sync deletion with remote, will retry later: $e');
        // TODO: Add to sync queue for later retry
      }
    }
  }
}
