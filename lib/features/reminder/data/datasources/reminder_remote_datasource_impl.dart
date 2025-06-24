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
    final response = await networkService.get<List<ReminderModel>>(
      '$reminderUserUrl/$userId',
      fromData: (data) {
        print('Data received: $data');
        return (data as List)
            .map((item) => ReminderModel.fromJson(item))
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
    final response = await networkService.post(
      '/reminders',
      body: reminder.toJson(),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add reminder');
    }
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    final response = await networkService.put(
      '/reminders/${reminder.id}',
      body: reminder.toJson(),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update reminder');
    }
  }

  @override
  Future<void> deleteReminder(int reminderId) async {
    final response = await networkService.delete('/reminders/$reminderId');
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
