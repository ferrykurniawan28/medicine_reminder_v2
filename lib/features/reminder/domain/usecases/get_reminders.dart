import '../entities/reminder.dart';
import '../repositories/reminder_repository.dart';

class GetReminders {
  final ReminderRepository repository;

  GetReminders(this.repository);

  Future<List<Reminder>> call(int userId) async {
    return await repository.getReminders(userId);
  }
}
