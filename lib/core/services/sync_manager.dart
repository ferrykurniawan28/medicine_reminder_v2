import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:medicine_reminder/features/appointment/data/datasources/appointment_local_datasource.dart';
import 'package:medicine_reminder/features/appointment/data/datasources/appointment_remote_datasource.dart';
import 'package:medicine_reminder/features/appointment/data/models/appointment_model.dart';
import 'package:medicine_reminder/features/reminder/data/datasources/reminder_local_datasource_interface.dart';
import 'package:medicine_reminder/features/reminder/data/datasources/reminder_remote_datasource.dart';
import 'package:medicine_reminder/features/reminder/domain/entities/reminder.dart';

/// A simple sync manager for offline-first apps.
class SyncManager {
  final Database db;
  final Connectivity connectivity;
  final StreamController<bool> _syncingController =
      StreamController.broadcast();
  bool _isSyncing = false;

  final AppointmentLocalDataSource appointmentLocalDataSource;
  final AppointmentRemoteDataSource appointmentRemoteDataSource;

  // Optional reminder sync components
  final ReminderLocalDataSource? reminderLocalDataSource;
  final ReminderRemoteDataSource? reminderRemoteDataSource;

  SyncManager({
    required this.db,
    required this.connectivity,
    required this.appointmentLocalDataSource,
    required this.appointmentRemoteDataSource,
    this.reminderLocalDataSource,
    this.reminderRemoteDataSource,
  });

  Stream<bool> get syncing => _syncingController.stream;

  Future<void> start() async {
    connectivity.onConnectivityChanged.listen((status) async {
      if (status.isNotEmpty && !status.contains(ConnectivityResult.none)) {
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
      await _syncReminders();
    } finally {
      _isSyncing = false;
      _syncingController.add(false);
    }
  }

  Future<void> _syncAppointments() async {
    await syncUnsyncedAppointments();
    await syncDeletedAppointments();
  }

  Future<void> _syncReminders() async {
    if (reminderLocalDataSource != null && reminderRemoteDataSource != null) {
      await syncUnsyncedReminders();
      await syncDeletedReminders();
    }
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
        print('Syncing deleted appointment: ${appointment.toJson()}');
        await _syncDeletedAppointment(appointment);
      }
    } catch (e) {
      print('Failed to sync deleted appointments: $e');
    }
  }

  Future<void> _syncDeletedAppointment(AppointmentModel appointment) async {
    if (appointment.id != null) {
      await appointmentLocalDataSource.deleteAppointment(appointment.id!);
      await appointmentRemoteDataSource.deleteAppointment(appointment.id!);
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

  Future<void> syncUnsyncedReminders() async {
    if (reminderLocalDataSource == null || reminderRemoteDataSource == null) {
      return;
    }

    try {
      final unsyncedReminders =
          await reminderLocalDataSource!.getUnsyncedReminders();

      for (var reminder in unsyncedReminders ?? []) {
        if (reminder.isDeleted == 1) {
          await _syncDeletedReminder(reminder);
        } else if (reminder.isUpdated == 1) {
          await reminderRemoteDataSource!.updateReminder(reminder);
          await reminderLocalDataSource!.markReminderAsSynced(reminder.id!);
        } else if (reminder.isSynced == 0) {
          await reminderRemoteDataSource!.addReminder(reminder);
          await reminderLocalDataSource!.markReminderAsSynced(reminder.id!);
        }
      }

      // Note: We'll need to implement getUnsyncedReminders without userId for sync manager
      // or modify the approach
      print('Syncing unsynced reminders...');
      // For now, we'll skip this since we need userId
      // In a real implementation, you might store the current user ID in the sync manager
    } catch (e) {
      print('Failed to sync unsynced reminders: $e');
    }
  }

  Future<void> syncDeletedReminders() async {
    if (reminderLocalDataSource == null || reminderRemoteDataSource == null) {
      return;
    }

    try {
      final deletedReminders =
          await reminderLocalDataSource!.getDeletedReminders();
      for (var reminder in deletedReminders) {
        print('Syncing deleted reminder: ${reminder.id}');
        await _syncDeletedReminder(reminder);
      }
    } catch (e) {
      print('Failed to sync deleted reminders: $e');
    }
  }

  Future<void> _syncDeletedReminder(Reminder reminder) async {
    if (reminder.id != null &&
        reminderLocalDataSource != null &&
        reminderRemoteDataSource != null) {
      await reminderLocalDataSource!.deleteReminder(reminder.id!);
      await reminderRemoteDataSource!.deleteReminder(reminder.id!);
    }
  }

  void dispose() {
    _syncingController.close();
  }
}

// Usage (in main or a Bloc):
// final syncManager = SyncManager(db: yourDb, connectivity: Connectivity());
// syncManager.start();
