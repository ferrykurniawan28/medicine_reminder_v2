import 'package:medicine_reminder/core/constant/url.dart';
import 'package:medicine_reminder/core/network/network_service.dart';
import 'package:medicine_reminder/features/appointment/data/models/appointment_model.dart';
import 'package:medicine_reminder/features/appointment/domain/entities/appointment.dart';
import 'package:medicine_reminder/features/device/data/models/device_model.dart';
import 'package:medicine_reminder/features/device/domain/entities/device.dart';
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
  Future<List<Appointment>> fetchParentalAppointments(int parentalId) async {
    try {
      final response = await networkService.get<List<AppointmentModel>>(
        '$parentalUrl/$parentalId/appointment',
        fromData: (data) {
          print('Parental appointments data received: $data');
          return (data as List).map((item) {
            // Handle the field name mismatch between API and model
            final appointmentJson = Map<String, dynamic>.from(item);

            // Map API field names to model field names
            if (appointmentJson.containsKey('createdBy')) {
              appointmentJson['created_by'] = appointmentJson['createdBy'];
              appointmentJson.remove('createdBy');
            }

            // If assignedTo is missing, use the same as createdBy or set a default
            if (!appointmentJson.containsKey('assigned_to')) {
              appointmentJson['assigned_to'] =
                  appointmentJson['created_by'] ?? parentalId;
            }

            return AppointmentModel.fromJson(appointmentJson);
          }).toList();
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        print(
            'Successfully fetched ${response.data!.length} parental appointments');
        return response.data!;
      } else {
        print(
            'Failed to fetch parental appointments - Status: ${response.statusCode}, Message: ${response.message}');
        throw Exception(
            'Failed to fetch parental appointments: Status ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchParentalAppointments: $e');
      throw Exception('Failed to fetch parental appointments: $e');
    }
  }

  @override
  Future<Device> fetchParentalDevice(int parentalId) async {
    try {
      final response = await networkService.get<DeviceModel>(
        '$parentalUrl/$parentalId/device',
        fromData: (data) {
          print('Parental device data received: $data');

          // Handle the case where API returns an array of devices
          if (data is List && data.isNotEmpty) {
            // Take the first device from the array
            return DeviceModel.fromJson(data.first as Map<String, dynamic>);
          } else if (data is Map<String, dynamic>) {
            // Handle single device response
            return DeviceModel.fromJson(data);
          } else {
            throw Exception('Invalid device data format: $data');
          }
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        print('Successfully fetched parental device');
        return response.data!;
      } else {
        print(
            'Failed to fetch parental device - Status: ${response.statusCode}, Message: ${response.message}');
        throw Exception(
            'Failed to fetch parental device: Status ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchParentalDevice: $e');
      throw Exception('Failed to fetch parental device: $e');
    }
  }

  @override
  Future<void> createParentalAppointment(
      AppointmentModel appointment, int parentalId) async {
    try {
      final response = await networkService.post(
        '$parentalUrl/$parentalId/appointment',
        body: appointment.toJson(),
      );

      if (response.statusCode == 201) {
        print('Successfully created parental appointment');
      } else {
        print(
            'Failed to create parental appointment - Status: ${response.statusCode}, Message: ${response.message}');
        throw Exception(
            'Failed to create parental appointment: Status ${response.statusCode}');
      }
    } catch (e) {
      print('Error in createParentalAppointment: $e');
      throw Exception('Failed to create parental appointment: $e');
    }
  }

  @override
  Future<void> createParentalReminder(
      ReminderModel reminder, int parentalId) async {
    try {
      print('Creating parental reminder: ${reminder.toJson()}');
      final response = await networkService.post(
        '$parentalUrl/$parentalId/reminder',
        body: reminder.toJson(),
      );

      if (response.statusCode == 201) {
        print('Successfully created parental reminder');
      } else {
        print(
            'Failed to create parental reminder - Status: ${response.statusCode}, Message: ${response.message}');
        throw Exception(
            'Failed to create parental reminder: Status ${response.statusCode}');
      }
    } catch (e) {
      print('Error in createParentalReminder: $e');
      throw Exception('Failed to create parental reminder: $e');
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
