import '../../domain/entities/reminder.dart';

abstract class ReminderLocalDataSource {
  Future<List<Reminder>> getReminders(int userId);
  Future<Reminder> addReminder(Reminder reminder, {bool isSynced = false});
  Future<void> updateReminder(Reminder reminder, {bool isSynced = false});
  Future<void> updateReminderStatus(Reminder reminder, {bool isSynced = false});
  Future<void> deleteReminder(int id);
  Future<void> clearReminders();
  Future<List<Reminder>?> getUnsyncedReminders();
  Future<void> markReminderAsSynced(int reminderIds);
  Future<void> markReminderAsDeleted(int reminderId);
  Future<List<Reminder>> getDeletedReminders();
  Future<void> markReminderNotSynced(int id);
  Future<void> markReminderAsNotUpdated(int id);
  Future<void> markReminderAsUpdated(int id);
}
