abstract class AppointmentRemoteRepository {
  Future<List<Map<String, dynamic>>> fetchAppointments({int? userId});
  Future<void> addAppointment(Map<String, dynamic> appointmentJson);
  Future<void> updateAppointment(int id, Map<String, dynamic> appointmentJson);
  Future<void> deleteAppointment(int id);
  Future<void> syncAppointments(List<Map<String, dynamic>> appointmentsToSync);
}
