import '../../domain/entities/reminder.dart';

abstract class ReminderLocalDataSource {
  Future<List<Reminder>> getReminders();
  Future<Reminder> addReminder(Reminder reminder);
  Future<void> updateReminder(Reminder reminder);
  Future<void> deleteReminder(int id);
  Future<void> clearReminders();
}
