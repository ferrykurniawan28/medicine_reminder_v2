import '../../domain/entities/reminder.dart' as domain;
import '../../domain/repositories/reminder_repository.dart';
import '../datasources/reminder_local_datasource_impl.dart';
import '../datasources/reminder_local_datasource_interface.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  final ReminderLocalDataSource localDataSource = ReminderLocalDataSourceImpl();

  @override
  Future<List<domain.Reminder>> getReminders() {
    return localDataSource.getReminders();
  }

  @override
  Future<domain.Reminder> addReminder(domain.Reminder reminder) {
    return localDataSource.addReminder(reminder);
  }

  @override
  Future<void> deleteReminder(int? id) {
    return localDataSource.deleteReminder(id!);
  }

  @override
  Future<void> updateReminder(domain.Reminder reminder) {
    return localDataSource.updateReminder(reminder);
  }
}
