import '../entities/reminder.dart';
import '../repositories/reminder_repository.dart';

class UpdateReminder {
  final ReminderRepository repository;
  UpdateReminder(this.repository);

  Future<void> call(Reminder reminder) async {
    await repository.updateReminder(reminder);
  }
}
