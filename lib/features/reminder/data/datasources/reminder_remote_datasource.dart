import '../../domain/entities/reminder.dart';

abstract class ReminderRemoteDataSource {
  Future<List<Reminder>> fetchReminders(int userId);
  Future<void> addReminder(Reminder reminder);
  Future<void> updateReminder(Reminder reminder);
  Future<void> updateReminderStatus(Reminder reminder);
  Future<void> deleteReminder(int reminderId);
  Future<void> syncReminders(List<Reminder> reminders);
  // Future<void> syncDeletedReminders(List<Reminder> reminders);
}
