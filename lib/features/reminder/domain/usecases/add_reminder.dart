import '../entities/reminder.dart';
import '../repositories/reminder_repository.dart';

class AddReminder {
  final ReminderRepository repository;

  AddReminder(this.repository);

  Future<Reminder> call(Reminder reminder) async {
    return await repository.addReminder(reminder);
  }
}
