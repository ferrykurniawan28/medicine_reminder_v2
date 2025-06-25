import '../../domain/entities/reminder.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../datasources/reminder_local_datasource_interface.dart';
import '../datasources/reminder_remote_datasource.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  final ReminderLocalDataSource localDataSource;
  final ReminderRemoteDataSource? remoteDataSource;
  final bool Function()? isOnline;

  ReminderRepositoryImpl(
    this.localDataSource, {
    this.remoteDataSource,
    this.isOnline,
  });

  @override
  Future<List<Reminder>> getReminders(int userId) async {
    if (isOnline != null && isOnline!() && remoteDataSource != null) {
      try {
        final remoteReminders = await remoteDataSource!.fetchReminders(userId);
        for (final reminder in remoteReminders) {
          await localDataSource.addReminder(reminder, isSynced: true);
        }
        return remoteReminders;
      } catch (e) {
        print('Error fetching reminders: $e');
        throw Exception('Failed to fetch reminders - $e');
      }
    }
    return localDataSource.getReminders(userId);
  }

  @override
  Future<Reminder> addReminder(Reminder reminder) async {
    if (isOnline != null && isOnline!() && remoteDataSource != null) {
      try {
        await remoteDataSource!.addReminder(reminder);
        return localDataSource.addReminder(reminder, isSynced: true);
      } catch (e) {
        // Log error and fallback to local data
      }
    }
    return localDataSource.addReminder(reminder, isSynced: false);
  }

  @override
  Future<void> deleteReminder(int id) async {
    if (isOnline != null && isOnline!() && remoteDataSource != null) {
      try {
        await remoteDataSource!.deleteReminder(id);
        await localDataSource.deleteReminder(id);
        return;
      } catch (e) {
        // Log error and fallback to local data
      }
    }
    await localDataSource.markReminderAsDeleted(id);
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    print('Updating reminder: ${reminder.toJson()}');
    if (isOnline != null && isOnline!() && remoteDataSource != null) {
      try {
        print('Updating reminder remotely: ${reminder.toJson()}');
        await remoteDataSource!.updateReminder(reminder);
        print('Reminder updated remotely successfully');
        await localDataSource.updateReminder(reminder, isSynced: true);
        return;
      } catch (e) {
        // Log error and fallback to local data
        print('Error updating reminder: $e');
        throw Exception('Failed to update reminder - $e');
      }
    }
    await localDataSource.updateReminder(reminder, isSynced: false);
  }

  @override
  Future<void> updateReminderStatus(Reminder reminder) async {
    if (isOnline != null && isOnline!() && remoteDataSource != null) {
      try {
        await remoteDataSource!.updateReminderStatus(reminder);
        await localDataSource.updateReminderStatus(reminder, isSynced: true);
        return;
      } catch (e) {
        // Log error and fallback to local data
        print('Error updating reminder status: $e');
        throw Exception('Failed to update reminder status - $e');
      }
    }
    await localDataSource.updateReminderStatus(reminder, isSynced: false);
  }
}
