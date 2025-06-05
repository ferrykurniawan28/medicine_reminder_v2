import '../models/appointment_model.dart';

abstract class AppointmentRemoteDataSource {
  Future<List<AppointmentModel>> fetchAppointments(int userId);
  Future<AppointmentModel?> fetchAppointment(int id);
  Future<AppointmentModel> addAppointment(AppointmentModel appointment);
  Future<void> updateAppointment(AppointmentModel appointment);
  Future<void> deleteAppointment(int id);
  Future<void> syncAppointments(List<AppointmentModel> unsyncedAppointments);
}
