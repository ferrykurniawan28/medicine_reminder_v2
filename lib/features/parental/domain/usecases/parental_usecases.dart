import 'package:medicine_reminder/features/appointment/domain/entities/appointment.dart';
import 'package:medicine_reminder/features/device/domain/entities/device.dart';
import 'package:medicine_reminder/features/reminder/domain/entities/reminder.dart';

import '../entities/parental.dart';
import '../repositories/parental_repository.dart';

class GetParentals {
  final ParentalRepository repository;

  GetParentals(this.repository);

  Future<List<Parental>> call(int userId) async {
    return await repository.getParentals(userId);
  }
}

class AddParental {
  final ParentalRepository repository;

  AddParental(this.repository);

  Future<void> call(Parental parental, int userId) async {
    await repository.addParental(parental, userId);
  }
}

class DeleteParental {
  final ParentalRepository repository;

  DeleteParental(this.repository);

  Future<void> call(int id) async {
    await repository.deleteParental(id);
  }
}

class GetParentalReminder {
  final ParentalRepository repository;

  GetParentalReminder(this.repository);

  Future<List<Reminder>> call(int parentalId) async {
    return await repository.getParentalReminders(parentalId);
  }
}

class GetParentalAppointment {
  final ParentalRepository repository;

  GetParentalAppointment(this.repository);

  Future<List<Appointment>> call(int parentalId) async {
    return await repository.getParentalAppointments(parentalId);
  }
}

class GetParentalDevice {
  final ParentalRepository repository;

  GetParentalDevice(this.repository);

  Future<Device> call(int parentalId) async {
    return await repository.getParentalDevice(parentalId);
  }
}

class AddParentalAppointment {
  final ParentalRepository repository;

  AddParentalAppointment(this.repository);

  Future<void> call(Appointment appointment, int parentalId) async {
    await repository.createParentalAppointment(appointment, parentalId);
  }
}

class AddParentalReminder {
  final ParentalRepository repository;

  AddParentalReminder(this.repository);

  Future<void> call(Reminder reminder, int parentalId) async {
    await repository.createParentalReminder(reminder, parentalId);
  }
}
