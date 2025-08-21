import 'package:medicine_reminder/core/constant/url.dart';
import 'package:medicine_reminder/core/network/network_service.dart';
import 'package:medicine_reminder/features/parental/data/models/parental_model.dart';
import 'package:medicine_reminder/features/reminder/data/models/reminder_model.dart';
import 'package:medicine_reminder/features/reminder/domain/entities/reminder.dart';
import '../../domain/entities/parental.dart';
import 'parental_remote_datasource.dart';

class ParentalRemoteDataSourceImpl implements ParentalRemoteDataSource {
  final NetworkService networkService;

  ParentalRemoteDataSourceImpl(this.networkService);

  @override
  Future<List<Parental>> fetchParentals(int userId) async {
    final response = await networkService.get<List<ParentalModel>>(
      '$parentalUrl/$userId',
      fromData: (data) {
        print('Parental data received: $data');
        return (data as List)
            .map((item) => ParentalModel.fromJson(item))
            .toList();
      },
    );

    if (response.statusCode == 200) {
      return response.data!;
    } else {
      throw Exception('Failed to fetch parentals: ${response.message}');
    }
  }

  @override
  Future<List<Reminder>> fetchParentalReminders(int parentalId) async {
    try {
      final response = await networkService.get<List<ReminderModel>>(
        '$parentalUrl/$parentalId/reminder',
        fromData: (data) {
          print('Parental reminders data received: $data');
          return (data as List).map((item) {
            // Handle the case where createdBy and assignedTo are integers
            final reminderJson = Map<String, dynamic>.from(item);

            // Convert integer user IDs to null for now, or create minimal User objects
            if (reminderJson['createdBy'] is int) {
              reminderJson['createdBy'] = null;
            }
            if (reminderJson['assignedTo'] is int) {
              reminderJson['assignedTo'] = null;
            }

            return ReminderModel.fromJson(reminderJson);
          }).toList();
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        print(
            'Successfully fetched ${response.data!.length} parental reminders');
        return response.data!;
      } else {
        print(
            'Failed to fetch parental reminders - Status: ${response.statusCode}, Message: ${response.message}');
        throw Exception(
            'Failed to fetch parental reminders: Status ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchParentalReminders: $e');
      throw Exception('Failed to fetch parental reminders: $e');
    }
  }

  @override
  Future<void> addParental(Parental parental) async {
    //TODO: add parental
  }

  @override
  Future<void> deleteParental(int parentalId) async {
    final response = await networkService.delete(
      '$parentalUrl/$parentalId',
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete parental: ${response.message}');
    }
  }
}
