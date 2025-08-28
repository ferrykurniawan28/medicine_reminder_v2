import '../models/appointment_model.dart';

abstract class AppointmentLocalDataSource {
  Future<List<AppointmentModel>> getAppointments(int userId);
  Future<AppointmentModel?> getAppointment(int id);
  Future<void> addAppointment(AppointmentModel appointment,
      {bool sync = false});
  Future<void> updateAppointment(AppointmentModel appointment,
      {bool sync = false});
  Future<void> deleteAppointment(int id);
  Future<void> markAppointmentAsDeleted(int id);
  Future<List<AppointmentModel>> getDeletedAppointments();
  Future<void> markAppointmentAsSynced(int id);
  Future<void> markAppointmentNotSynced(int id);
  Future<List<AppointmentModel>> getUnsyncedAppointments();
  Future<void> markAppointmentAsNotUpdated(int id);
  Future<void> markAppointmentAsUpdated(int id);
}
