import '../entities/reminder.dart';
import '../repositories/reminder_repository.dart';

class UpdateReminderStatus {
  final ReminderRepository repository;

  UpdateReminderStatus(this.repository);

  Future<void> call(Reminder reminder) async {
    await repository.updateReminderStatus(reminder);
  }
}
