import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/medical_record.dart';
import '../../domain/repositories/medical_record_repository.dart';
import '../../domain/usecases/medical_record_usecases.dart';

part 'medical_record_event.dart';
part 'medical_record_state.dart';

class MedicalRecordBloc extends Bloc<MedicalRecordEvent, MedicalRecordState> {
  final MedicalRecordRepository medicalRecordRepository;

  late final GetMedicalRecords getMedicalRecords;
  late final GetMedicalRecord getMedicalRecord;
  late final GetReminderRecords getReminderRecords;
  late final GetAppointmentRecords getAppointmentRecords;

  MedicalRecordBloc({required this.medicalRecordRepository})
      : super(MedicalRecordInitial()) {
    getMedicalRecords = GetMedicalRecords(medicalRecordRepository);
    getMedicalRecord = GetMedicalRecord(medicalRecordRepository);
    getReminderRecords = GetReminderRecords(medicalRecordRepository);
    getAppointmentRecords = GetAppointmentRecords(medicalRecordRepository);

    on<LoadMedicalRecords>(_onLoadMedicalRecords);
    on<LoadMedicalRecord>(_onLoadMedicalRecord);
    on<LoadReminderRecords>(_onLoadReminderRecords);
    on<LoadAppointmentRecords>(_onLoadAppointmentRecords);
    on<RefreshMedicalRecords>(_onRefreshMedicalRecords);
  }

  Future<void> _onLoadMedicalRecords(
    LoadMedicalRecords event,
    Emitter<MedicalRecordState> emit,
  ) async {
    try {
      emit(MedicalRecordLoading());
      print('Loading medical records...');

      final records = await getMedicalRecords(
        userId: event.userId,
        type: event.type,
        status: event.status,
        startDate: event.startDate,
        endDate: event.endDate,
        page: event.page,
        limit: event.limit,
      );

      print('Loaded ${records.length} medical records');
      emit(MedicalRecordsLoaded(records));
    } catch (e) {
      print('Error loading medical records: $e');
      emit(MedicalRecordError(
          'Failed to load medical records: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMedicalRecord(
    LoadMedicalRecord event,
    Emitter<MedicalRecordState> emit,
  ) async {
    try {
      emit(MedicalRecordLoading());
      print('Loading medical record with ID: ${event.id}');

      final record = await getMedicalRecord(event.id);

      if (record != null) {
        print('Loaded medical record: ${record.type}');
        emit(MedicalRecordLoaded(record));
      } else {
        emit(const MedicalRecordError('Medical record not found'));
      }
    } catch (e) {
      print('Error loading medical record: $e');
      emit(
          MedicalRecordError('Failed to load medical record: ${e.toString()}'));
    }
  }

  Future<void> _onLoadReminderRecords(
    LoadReminderRecords event,
    Emitter<MedicalRecordState> emit,
  ) async {
    try {
      emit(MedicalRecordLoading());
      print('Loading reminder records...');

      final records = await getReminderRecords(
        userId: event.userId,
        status: event.status,
        startDate: event.startDate,
        endDate: event.endDate,
      );

      print('Loaded ${records.length} reminder records');
      emit(ReminderRecordsLoaded(records));
    } catch (e) {
      print('Error loading reminder records: $e');
      emit(MedicalRecordError(
          'Failed to load reminder records: ${e.toString()}'));
    }
  }

  Future<void> _onLoadAppointmentRecords(
    LoadAppointmentRecords event,
    Emitter<MedicalRecordState> emit,
  ) async {
    try {
      emit(MedicalRecordLoading());
      print('Loading appointment records...');

      final records = await getAppointmentRecords(
        userId: event.userId,
        status: event.status,
        startDate: event.startDate,
        endDate: event.endDate,
      );

      print('Loaded ${records.length} appointment records');
      emit(AppointmentRecordsLoaded(records));
    } catch (e) {
      print('Error loading appointment records: $e');
      emit(MedicalRecordError(
          'Failed to load appointment records: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshMedicalRecords(
    RefreshMedicalRecords event,
    Emitter<MedicalRecordState> emit,
  ) async {
    // Force refresh by calling load with fresh data
    add(LoadMedicalRecords(
      userId: event.userId,
      type: event.type,
      status: event.status,
      startDate: event.startDate,
      endDate: event.endDate,
      page: event.page,
      limit: event.limit,
    ));
  }
}
