import 'package:medicine_reminder/core/constant/url.dart';
import 'package:medicine_reminder/core/network/network_service.dart';

import 'appointment_remote_datasource.dart';
import '../models/appointment_model.dart';

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final NetworkService networkService;

  AppointmentRemoteDataSourceImpl(this.networkService);

  @override
  Future<List<AppointmentModel>> fetchAppointments(int userId) async {
    final response = await networkService.get<List<AppointmentModel>>(
      '$appointmentUserUrl/$userId',
      fromData: (data) => (data as List)
          .map((item) => AppointmentModel.fromJson(item))
          .toList(),
    );

    if (response.statusCode == 200) {
      final appointments = response.data;
      return appointments!;
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  @override
  Future<AppointmentModel?> fetchAppointment(int id) async {
    final response = await networkService.get<AppointmentModel>(
      '$appointmentUrl/$id',
      fromData: (data) => AppointmentModel.fromJson(data),
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load appointment with id $id');
    }
  }

  @override
  Future<AppointmentModel> addAppointment(AppointmentModel appointment) async {
    final body = {
      'created_by': appointment.userCreated.userId,
      'assigned_to': appointment.userAssigned.userId,
      'doctor': appointment.doctor,
      'notes': appointment.note,
      'dates': appointment.time.toUtc().toIso8601String(),
    };

    late AppointmentModel addedAppointment;
    final response = await networkService.post<AppointmentModel>(
      appointmentUrl,
      body: body,
      fromData: (data) => addedAppointment = AppointmentModel.fromJson(data),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add appointment');
    }

    // Return the added appointment with its ID
    return addedAppointment;
  }

  @override
  Future<void> updateAppointment(AppointmentModel appointment) async {
    final response = await networkService.put<AppointmentModel>(
      '$appointmentUrl/${appointment.id}',
      body: {
        'doctor': appointment.doctor,
        'notes': appointment.note,
        'dates': '${appointment.time.toUtc().toIso8601String()}Z',
      },
      fromData: (data) => AppointmentModel.fromJson(data),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to update appointment with id \\${appointment.id}');
    }
  }

  @override
  Future<void> deleteAppointment(int id) async {
    final response = await networkService.delete(
      '$appointmentUrl/$id',
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete appointment with id $id');
    }
  }

  @override
  Future<void> syncAppointments(
      List<AppointmentModel> unsyncedAppointments) async {
    for (var appointment in unsyncedAppointments) {
      try {
        if (appointment.id == null) {
          await addAppointment(appointment);
        } else {
          await updateAppointment(appointment);
        }
      } catch (e) {
        // Handle individual sync errors, e.g., log them
        print('Failed to sync appointment ${appointment.id}: $e');
      }
    }
  }
}
