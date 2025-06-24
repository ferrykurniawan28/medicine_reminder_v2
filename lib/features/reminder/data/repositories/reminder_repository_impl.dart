import '../../domain/entities/reminder.dart' as domain;
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
  Future<List<domain.Reminder>> getReminders(int userId) async {
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
  Future<domain.Reminder> addReminder(domain.Reminder reminder) async {
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
  Future<void> updateReminder(domain.Reminder reminder) async {
    if (isOnline != null && isOnline!() && remoteDataSource != null) {
      try {
        await remoteDataSource!.updateReminder(reminder);
        await localDataSource.updateReminder(reminder);
        return;
      } catch (e) {
        // Log error and fallback to local data
      }
    }
    await localDataSource.updateReminder(reminder, isSynced: false);
  }
}
