import '../entities/appointment.dart';

abstract class AppointmentRepository {
  Future<List<Appointment>> getAppointments(int userId);
  Future<Appointment?> getAppointment(int id);
  Future<void> addAppointment(Appointment appointment);
  Future<void> updateAppointment(Appointment appointment);
  Future<void> deleteAppointment(int id);
  Future<void> syncUnsyncedAppointments();
  Future<void> syncDeletedAppointments();
}
