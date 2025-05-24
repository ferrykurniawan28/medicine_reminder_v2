import '../entities/appointment.dart';
import '../repositories/appointment_repository.dart';

class UpdateAppointment {
  final AppointmentRepository repository;
  UpdateAppointment(this.repository);
  Future<void> call(Appointment appointment) =>
      repository.updateAppointment(appointment);
}
