abstract class ReminderRemoteRepository {
  Future<List<Map<String, dynamic>>> fetchReminders({int? userId});
  Future<void> addReminder(Map<String, dynamic> reminderJson);
  Future<void> updateReminder(int id, Map<String, dynamic> reminderJson);
  Future<void> deleteReminder(int id);
  Future<void> syncReminders(List<Map<String, dynamic>> remindersToSync);
}
