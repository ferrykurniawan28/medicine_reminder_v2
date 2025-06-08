import '../../domain/entities/appointment.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../datasources/appointment_local_datasource.dart';
import '../datasources/appointment_remote_datasource.dart';
import '../models/appointment_model.dart';
import 'package:medicine_reminder/core/services/sync_manager.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentLocalDataSource localDataSource;
  final AppointmentRemoteDataSource? remoteDataSource;
  final bool Function()? isOnline;
  final SyncManager syncManager; // Updated to use centralized SyncManager

  AppointmentRepositoryImpl(
    this.localDataSource, {
    this.remoteDataSource,
    this.isOnline,
    required this.syncManager,
  });

  @override
  Future<List<Appointment>> getAppointments(int userId) async {
    await syncManager.syncDeletedAppointments();
    await syncManager.syncUnsyncedAppointments();

    // Always read from local for offline-first
    final local = await localDataSource.getAppointments(userId);

    // Map local data to domain objects
    final localMapped = local
        .map((model) => Appointment(
              id: model.id,
              userCreated: model.userCreated,
              userAssigned: model.userAssigned,
              doctor: model.doctor,
              note: model.note,
              time: model.time,
            ))
        .toList();

    if (isOnline != null && isOnline!() && remoteDataSource != null) {
      try {
        final remote = await remoteDataSource!.fetchAppointments(userId);

        // Map remote data to domain objects
        final remoteMapped = remote
            .map((model) => Appointment(
                  id: model.id,
                  userCreated: model.userCreated,
                  userAssigned: model.userAssigned,
                  doctor: model.doctor,
                  note: model.note,
                  time: model.time,
                ))
            .toList();

        // Optionally: update local DB with remote data
        for (var appointmentModel
            in remoteMapped.map(AppointmentModel.fromDomain)) {
          await localDataSource.addAppointment(appointmentModel);
          await localDataSource.markAppointmentAsSynced(appointmentModel.id!);
        }

        return remoteMapped;
      } catch (_) {
        return localMapped;
      }
    }
    return localMapped;
  }

  @override
  Future<Appointment?> getAppointment(int id) async {
    final local = await localDataSource.getAppointment(id);
    if (isOnline != null && isOnline!() && remoteDataSource != null) {
      try {
        final remote = await remoteDataSource!.fetchAppointment(id);
        // Optionally: update local DB with remote data
        // ...
        return remote;
      } catch (_) {
        return local;
      }
    }
    return local;
  }

  @override
  Future<void> addAppointment(Appointment appointment) async {
    final model = AppointmentModel(
      id: appointment.id,
      userCreated: appointment.userCreated,
      userAssigned: appointment.userAssigned,
      doctor: appointment.doctor,
      note: appointment.note,
      time: appointment.time,
    );
    await localDataSource.addAppointment(model);
    if (isOnline != null && isOnline!()) {
      await syncManager.syncUnsyncedAppointments();
    }
  }

  @override
  Future<void> updateAppointment(Appointment appointment) async {
    final model = AppointmentModel(
      id: appointment.id,
      userCreated: appointment.userCreated,
      userAssigned: appointment.userAssigned,
      doctor: appointment.doctor,
      note: appointment.note,
      time: appointment.time,
    );
    await localDataSource.updateAppointment(model);
    if (isOnline != null && isOnline!()) {
      await syncManager.syncUnsyncedAppointments();
    }
  }

  @override
  Future<void> deleteAppointment(int id) async {
    await localDataSource.markAppointmentAsDeleted(id);
    if (isOnline != null && isOnline!()) {
      await syncManager.syncDeletedAppointments();
    }
  }

  @override
  Future<void> syncUnsyncedAppointments() async {
    await syncManager.syncUnsyncedAppointments();
  }

  @override
  Future<void> syncDeletedAppointments() async {
    await syncManager.syncDeletedAppointments();
  }
}
