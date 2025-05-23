import '../entities/reminder.dart';
import '../repositories/reminder_repository.dart';

class GetReminders {
  final ReminderRepository repository;

  GetReminders(this.repository);

  Future<List<Reminder>> call() async {
    return await repository.getReminders();
  }
}
