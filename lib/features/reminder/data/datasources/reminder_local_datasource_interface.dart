import '../../domain/entities/reminder.dart';

abstract class ReminderLocalDataSource {
  Future<List<Reminder>> getReminders(int userId);
  Future<Reminder> addReminder(Reminder reminder, {bool isSynced = false});
  Future<void> updateReminder(Reminder reminder, {bool isSynced = false});
  Future<void> deleteReminder(int id);
  Future<void> clearReminders();
  Future<List<Reminder>?> getUnsyncedReminders(int userId);
  Future<void> markReminderAsSynced(int reminderIds);
  Future<void> markReminderAsDeleted(int reminderId);
}
