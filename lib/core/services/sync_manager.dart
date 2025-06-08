import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:medicine_reminder/features/appointment/data/datasources/appointment_local_datasource.dart';
import 'package:medicine_reminder/features/appointment/data/datasources/appointment_remote_datasource.dart';
import 'package:medicine_reminder/features/appointment/data/models/appointment_model.dart';

/// A simple sync manager for offline-first apps.
class SyncManager {
  final Database db;
  final Connectivity connectivity;
  final StreamController<bool> _syncingController =
      StreamController.broadcast();
  bool _isSyncing = false;

  final AppointmentLocalDataSource appointmentLocalDataSource;
  final AppointmentRemoteDataSource appointmentRemoteDataSource;

  SyncManager({
    required this.db,
    required this.connectivity,
    required this.appointmentLocalDataSource,
    required this.appointmentRemoteDataSource,
  });

  Stream<bool> get syncing => _syncingController.stream;

  Future<void> start() async {
    connectivity.onConnectivityChanged.listen((status) async {
      if (status != ConnectivityResult.none) {
        await syncAll();
      }
    });
  }

  Future<void> syncAll() async {
    if (_isSyncing) return;
    _isSyncing = true;
    _syncingController.add(true);
    try {
      await _syncAppointments();
      // Add other feature sync methods here
    } finally {
      _isSyncing = false;
      _syncingController.add(false);
    }
  }

  Future<void> _syncAppointments() async {
    await syncUnsyncedAppointments();
    await syncDeletedAppointments();
  }

  Future<void> syncUnsyncedAppointments() async {
    try {
      final unsyncedAppointments =
          await appointmentLocalDataSource.getUnsyncedAppointments();
      for (var appointment in unsyncedAppointments) {
        if (appointment.isDeleted == 1) {
          await _syncDeletedAppointment(appointment);
        } else if (appointment.isUpdated == 1) {
          await _syncUpdatedAppointment(appointment);
        } else if (appointment.isSynced == 0) {
          await _syncNewAppointment(appointment);
        }
      }
    } catch (e) {
      print('Failed to sync unsynced appointments: $e');
    }
  }

  Future<void> syncDeletedAppointments() async {
    try {
      final deletedAppointments =
          await appointmentLocalDataSource.getDeletedAppointments();
      for (var appointment in deletedAppointments) {
        await _syncDeletedAppointment(appointment);
      }
    } catch (e) {
      print('Failed to sync deleted appointments: $e');
    }
  }

  Future<void> _syncDeletedAppointment(AppointmentModel appointment) async {
    if (appointment.id != null) {
      await appointmentRemoteDataSource.deleteAppointment(appointment.id!);
      await appointmentLocalDataSource.deleteAppointment(appointment.id!);
    }
  }

  Future<void> _syncUpdatedAppointment(AppointmentModel appointment) async {
    if (appointment.id != null) {
      await appointmentRemoteDataSource.updateAppointment(appointment);
      await appointmentLocalDataSource.markAppointmentAsSynced(appointment.id!);
    }
  }

  Future<void> _syncNewAppointment(AppointmentModel appointment) async {
    if (appointment.id != null) {
      await appointmentRemoteDataSource.addAppointment(appointment);
      await appointmentLocalDataSource.markAppointmentAsSynced(appointment.id!);
    }
  }

  void dispose() {
    _syncingController.close();
  }
}

// Usage (in main or a Bloc):
// final syncManager = SyncManager(db: yourDb, connectivity: Connectivity());
// syncManager.start();
