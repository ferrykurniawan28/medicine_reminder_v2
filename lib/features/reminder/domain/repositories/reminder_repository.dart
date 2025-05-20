import '../entities/reminder.dart';

abstract class ReminderRepository {
  Future<List<Reminder>> getReminders();
  Future<Reminder> addReminder(Reminder reminder);
  Future<void> deleteReminder(int id);
  Future<void> updateReminder(Reminder reminder);
}
