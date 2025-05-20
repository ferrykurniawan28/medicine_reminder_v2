import '../../data/models/reminder_model.dart' as app;
import 'package:flutter/material.dart';
import '../../domain/entities/reminder.dart' as domain;
import '../../domain/repositories/reminder_repository.dart';
import '../datasources/reminder_local_datasource.dart';

// Mapper functions
app.ReminderModel domainToApp(domain.Reminder reminder) {
  return app.ReminderModel(
    id: reminder.id,
    medicineName: reminder.title,
    dosage: [1], // Placeholder, adapt as needed
    type: app.ReminderType.onceDaily, // Use a valid enum value
    times: [TimeOfDay.fromDateTime(reminder.dateTime)], // Placeholder
  );
}

domain.Reminder appToDomain(app.ReminderModel reminder) {
  return domain.Reminder(
    id: reminder.id ?? 0,
    title: reminder.medicineName,
    dateTime: reminder.times.isNotEmpty
        ? DateTime(
            0, 0, 0, reminder.times.first.hour, reminder.times.first.minute)
        : DateTime.now(),
  );
}

class ReminderRepositoryImpl implements ReminderRepository {
  final ReminderLocalDataSource localDataSource = ReminderLocalDataSource();

  @override
  Future<List<domain.Reminder>> getReminders() {
    return localDataSource.getReminders();
  }

  @override
  Future<void> addReminder(domain.Reminder reminder) {
    return localDataSource.addReminder(reminder);
  }

  @override
  Future<void> deleteReminder(int id) {
    return localDataSource.deleteReminder(id);
  }

  @override
  Future<void> updateReminder(domain.Reminder reminder) {
    return localDataSource.updateReminder(reminder);
  }
}
