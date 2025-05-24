import '../entities/appointment.dart';
import '../repositories/appointment_repository.dart';

class AddAppointment {
  final AppointmentRepository repository;
  AddAppointment(this.repository);
  Future<void> call(Appointment appointment) =>
      repository.addAppointment(appointment);
}
