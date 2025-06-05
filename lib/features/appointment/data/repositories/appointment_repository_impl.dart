import '../../domain/entities/appointment.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../datasources/appointment_local_datasource.dart';
import '../datasources/appointment_remote_datasource.dart';
import '../models/appointment_model.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentLocalDataSource localDataSource;
  final AppointmentRemoteDataSource? remoteDataSource;
  final bool Function()? isOnline;

  AppointmentRepositoryImpl(
    this.localDataSource, {
    this.remoteDataSource,
    this.isOnline,
  });

  @override
  Future<List<Appointment>> getAppointments(int userId) async {
    // Sync deleted appointments before fetching
    // await syncDeletedAppointments();
    // Sync unsynced appointments before fetching
    await syncUnsyncedAppointments();

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
        // print(remoteMapped.map((m) => m.toJson()).toList());
        // Optionally: update local DB with remote data
        for (var appointmentModel
            in remoteMapped.map(AppointmentModel.fromDomain)) {
          await localDataSource.addAppointment(appointmentModel);
          await localDataSource.markAppointmentAsSynced(appointmentModel.id!);
        }
        // Return remote data if successful
        print('remote: ${remoteMapped.map((m) => m.toJson()).toList()}');

        return remoteMapped;
      } catch (_) {
        // Fallback to local if remote fails
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
    // Optionally sync to remote if online
    if (isOnline != null && isOnline!() && remoteDataSource != null) {
      try {
        final addedAppointment = await remoteDataSource!.addAppointment(model);
        // Add to local DB with ID from remote
        await localDataSource.addAppointment(addedAppointment);
        // Optionally: mark as synced in local DB
        await localDataSource.markAppointmentAsSynced(addedAppointment.id!);
      } catch (_) {
        // Remain unsynced
      }
      // await localDataSource.addAppointment(model);
    } else {
      await localDataSource.addAppointment(model);
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

    if (isOnline != null && isOnline!() && remoteDataSource != null) {
      try {
        // Update on remote server first
        await remoteDataSource!.updateAppointment(model);

        // Then update locally without needing the `is_updated` flag
        await localDataSource.updateAppointment(model);
        await localDataSource.markAppointmentAsSynced(model.id!);
      } catch (_) {
        // Handle failure to sync with remote
        print('Failed to update appointment on remote server.');
      }
    } else {
      // If offline, update locally and set the `is_updated` flag
      await localDataSource.updateAppointment(model);
      await localDataSource.markAppointmentNotSynced(model.id!);
    }
  }

  @override
  Future<void> deleteAppointment(int id) async {
    // Mark as deleted locally

    // Sync deletion with server if online
    if (isOnline != null && isOnline!() && remoteDataSource != null) {
      try {
        print('Deleting appointment $id from local DB');
        await localDataSource.deleteAppointment(id);

        print('Syncing deletion for appointment $id');
        await remoteDataSource?.deleteAppointment(id);

        // Optionally: remove from local DB after successful sync
      } catch (_) {
        // Handle sync failure (e.g., retry or log)
        print('Failed to sync deletion for appointment $id');
      }
    } else {
      // If offline, just mark as deleted locally
      await localDataSource.markAppointmentAsDeleted(id);
    }
  }

  Future<void> syncDeletedAppointments() async {
    if (isOnline != null && isOnline!() && remoteDataSource != null) {
      try {
        final deletedAppointments =
            await localDataSource.getDeletedAppointments();
        for (var appointment in deletedAppointments) {
          if (appointment.id != null) {
            await remoteDataSource?.deleteAppointment(appointment.id!);
            await localDataSource.deleteAppointment(
                appointment.id!); // Remove from local DB after successful sync
          }
        }
      } catch (e) {
        print('Failed to sync deleted appointments: $e');
      }
    }
  }

  Future<void> syncUnsyncedAppointments() async {
    if (isOnline != null && isOnline!() && remoteDataSource != null) {
      try {
        final unsyncedAppointments =
            await localDataSource.getUnsyncedAppointments().then((models) {
          print(models.map((m) => m.toJson()).toList());
          return models;
        });
        print('Unsynced appointments: ${unsyncedAppointments.length}');
        for (var appointment in unsyncedAppointments) {
          print('Syncing appointment: ${appointment.toJson()}');
          if (appointment.isDeleted == 1) {
            // Sync deleted appointments
            if (appointment.id != null) {
              print('Deleting appointment with ID: ${appointment.id}');
              await remoteDataSource?.deleteAppointment(appointment.id!);
              await localDataSource.deleteAppointment(appointment
                  .id!); // Remove from local DB after successful sync
            }
          } else if (appointment.isUpdated == 1) {
            // Sync updated appointments
            print('Updating appointment with ID: ${appointment.id}');
            await remoteDataSource?.updateAppointment(appointment);
            await localDataSource.markAppointmentAsSynced(appointment.id!);
            await localDataSource.markAppointmentAsNotUpdated(
                appointment.id!); // Clear the updated flag
          } else if (appointment.isSynced == 0) {
            // Sync new appointments
            print('Adding new appointment to remote DB');
            final addedAppointment =
                await remoteDataSource?.addAppointment(appointment);

            if (addedAppointment != null) {
              print('Added appointment with new ID: ${addedAppointment.id}');
              // Update local DB with server-generated ID
              await localDataSource
                  .deleteAppointment(appointment.id!); // Remove old entry
              await localDataSource.addAppointment(
                  addedAppointment); // Add new entry with server ID
              await localDataSource
                  .markAppointmentAsSynced(addedAppointment.id!);
            }
          }
        }
      } catch (e) {
        print('Failed to sync unsynced appointments: $e');
      }
    } else {
      print('Device is offline or remote data source is null');
    }
  }
}
