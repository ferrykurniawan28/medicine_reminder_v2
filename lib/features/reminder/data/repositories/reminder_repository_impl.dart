import 'package:medicine_reminder/core/services/sync_manager.dart';

import '../../domain/entities/reminder.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../datasources/reminder_local_datasource_interface.dart';
import '../datasources/reminder_remote_datasource.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  final ReminderLocalDataSource localDataSource;
  final ReminderRemoteDataSource? remoteDataSource;
  final bool Function()? isOnline;
  final SyncManager syncManager; // Updated to use centralized SyncManager

  ReminderRepositoryImpl(
    this.localDataSource, {
    this.remoteDataSource,
    this.isOnline,
    required this.syncManager,
  });

  @override
  Future<List<Reminder>> getReminders(int userId) async {
    // Offline-first approach: always read from local first
    final local = await localDataSource.getReminders(userId);

    // If online and remote available, try to sync
    if (isOnline != null && isOnline!() && remoteDataSource != null) {
      try {
        await syncManager.syncDeletedReminders();
        await syncManager.syncUnsyncedReminders();

        print('Fetching reminders from remote data source');
        final remoteReminders = await remoteDataSource!.fetchReminders(userId);
        print('Remote reminders fetched: ${remoteReminders.length}');

        // Update local DB with remote data
        for (final reminder in remoteReminders) {
          await localDataSource.addReminder(reminder, isSynced: true);
        }
        return remoteReminders;
      } catch (e) {
        print('Error fetching reminders from remote: $e');
        // Fallback to local data
        return local;
      }
    }
    return local;
  }

  @override
  Future<Reminder> addReminder(Reminder reminder) async {
    // Always add to local first (offline-first)
    final localReminder =
        await localDataSource.addReminder(reminder, isSynced: false);

    // Try to sync immediately if online
    if (isOnline != null && isOnline!() && remoteDataSource != null) {
      try {
        await remoteDataSource!.addReminder(reminder);
        // Mark as synced if remote succeeded
        await localDataSource.markReminderAsSynced(localReminder.id!);
        return localReminder.copyWith(); // Return synced version
      } catch (e) {
        print('Failed to sync new reminder to remote: $e');
        // Return local version (will be synced later)
      }
    }
    return localReminder;
  }

  @override
  Future<void> deleteReminder(int id) async {
    // Mark as deleted locally first (offline-first)
    await localDataSource.markReminderAsDeleted(id);

    // Try to sync immediately if online
    if (isOnline != null && isOnline!() && remoteDataSource != null) {
      try {
        await remoteDataSource!.deleteReminder(id);
        // Actually delete locally after successful remote deletion
        await localDataSource.deleteReminder(id);
      } catch (e) {
        print('Failed to delete reminder from remote: $e');
        // Keep marked as deleted for later sync
      }
    }
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    print('Updating reminder: ${reminder.toJson()}');

    // Always update local first (offline-first)
    // await localDataSource.updateReminder(reminder, isSynced: false);
//
    // Try to sync immediately if online
    if (isOnline != null && isOnline!() && remoteDataSource != null) {
      try {
        print('Updating reminder remotely: ${reminder.toJson()}');
        await remoteDataSource!.updateReminder(reminder);
        print('Reminder updated remotely successfully');
        // Mark as synced if remote succeeded
        await localDataSource.updateReminder(reminder, isSynced: true);
      } catch (e) {
        print('Error updating reminder remotely: $e');
        // Keep marked as unsynced for later sync
      }
    } else {
      // If offline, just update locally
      await localDataSource.updateReminder(reminder, isSynced: false);
    }
  }

  @override
  Future<void> updateReminderStatus(Reminder reminder) async {
    // Always update local first (offline-first)
    // await localDataSource.updateReminderStatus(reminder, isSynced: false);

    // Try to sync immediately if online
    if (isOnline != null && isOnline!() && remoteDataSource != null) {
      try {
        await remoteDataSource!.updateReminderStatus(reminder);
        // Mark as synced if remote succeeded
        await localDataSource.updateReminderStatus(reminder, isSynced: true);
      } catch (e) {
        print('Error updating reminder status remotely: $e');
        // Keep marked as unsynced for later sync
      }
    } else {
      // If offline, just update locally
      await localDataSource.updateReminderStatus(reminder, isSynced: false);
    }
  }

  @override
  Future<void> syncUnsyncedReminders() async {
    await syncManager.syncUnsyncedReminders();
  }

  @override
  Future<void> syncDeletedReminders() async {
    if (remoteDataSource == null) return;

    try {
      final deletedReminders = await localDataSource.getDeletedReminders();
      for (var reminder in deletedReminders) {
        print('Syncing deleted reminder: ${reminder.id}');
        if (reminder.id != null) {
          await remoteDataSource!.deleteReminder(reminder.id!);
          await localDataSource.deleteReminder(reminder.id!);
        }
      }
    } catch (e) {
      print('Failed to sync deleted reminders: $e');
    }
  }
}
