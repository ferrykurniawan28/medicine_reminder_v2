import '../entities/reminder.dart';

abstract class ReminderRepository {
  Future<List<Reminder>> getReminders();
  Future<void> addReminder(Reminder reminder);
  Future<void> deleteReminder(int id);
  Future<void> updateReminder(Reminder reminder);
}
