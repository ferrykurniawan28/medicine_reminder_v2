import 'package:medicine_reminder/core/constant/url.dart';
import 'package:medicine_reminder/core/network/network_service.dart';
import 'package:medicine_reminder/features/reminder/data/models/reminder_model.dart';
import '../../domain/entities/reminder.dart';
import 'reminder_remote_datasource.dart';

class ReminderRemoteDataSourceImpl implements ReminderRemoteDataSource {
  final NetworkService networkService;

  ReminderRemoteDataSourceImpl(this.networkService);

  @override
  Future<List<Reminder>> fetchReminders(int userId) async {
    final response = await networkService.get<List<Reminder>>(
      '$reminderUserUrl/$userId',
      fromData: (data) {
        print('Data received: $data');
        return (data as List)
            .map((item) => ReminderModel.fromJson(item) as Reminder)
            .toList();
      },
    );
    if (response.statusCode == 200) {
      return response.data!;
    } else {
      throw Exception('Failed to fetch reminders');
    }
  }

  @override
  Future<void> addReminder(Reminder reminder) async {
    final body = {
      "deviceId": reminder.deviceId,
      "containerId": reminder.containerId,
      "medicineName": reminder.medicineName,
      "dosage": reminder.dosage.map((d) => d).toList(),
      "isActive": reminder.isActive,
      "isAlert": reminder.isAlert,
      "note": reminder.note,
      "type": ReminderTypeHelper.getName(reminder.type),
      "times": reminder.times
          .map((time) =>
              '${time.toDateTime().toIso8601String()}Z') //TODO: change format
          .toList(),
      "daysofWeek": reminder.daysofWeek?.map((day) => day.index).toList(),
      "endDate": reminder.endDate?.toIso8601String(),
      "assignedTo": reminder.assignedTo?.userId,
      "createdBy": reminder.createdBy?.userId,
    };
    final response = await networkService.post(
      reminderUrl,
      body: body,
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add reminder');
    }
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    final body = {
      "deviceId": reminder.deviceId,
      "containerId": reminder.containerId,
      "medicineName": reminder.medicineName,
      "dosage": reminder.dosage,
      "isActive": reminder.isActive,
      "isAlert": reminder.isActive,
      "note": reminder.note,
      "type": ReminderTypeHelper.getName(reminder.type),
      "times": reminder.times.map((time) => time.toString()).join(';'),
      "daysofWeek": reminder.daysofWeek?.map((day) => day.index).join(','),
      "endDate": reminder.endDate?.toIso8601String(),
      "assignedTo": reminder.assignedTo?.userId,
      "createdBy": reminder.createdBy?.userId,
    };
    final response = await networkService.put(
      '$reminderUrl/${reminder.id}',
      body: body,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update reminder');
    }
  }

  @override
  Future<void> updateReminderStatus(Reminder reminder) async {
    final body = {
      "isActive": reminder.isActive,
    };
    final response = await networkService.put(
      '$reminderUrl/${reminder.id}',
      body: body,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update reminder status');
    }
  }

  @override
  Future<void> deleteReminder(int reminderId) async {
    final response = await networkService.delete(
      '$reminderUrl/$reminderId',
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete reminder');
    }
  }

  @override
  Future<void> syncReminders(List<Reminder> reminders) async {
    for (final reminder in reminders) {
      try {
        if (reminder.id == null) {
          await addReminder(reminder);
        } else {
          await updateReminder(reminder);
        }
      } catch (e) {
        // Handle individual reminder sync failure
        print('Failed to sync reminder ${reminder.id}: $e');
      }
    }
  }

  // @override
  // Future<void> syncDeletedReminders(List<Reminder> reminders) async {
  //   final response = await networkService.post(
  //     '/reminders/sync-deleted',
  //     body: reminders.map((r) => r.toJson()).toList(),
  //   );

  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to sync deleted reminders');
  //   }
  // }
}
