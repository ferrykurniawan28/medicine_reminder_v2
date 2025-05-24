import '../repositories/appointment_repository.dart';

class GetAppointment {
  final AppointmentRepository repository;
  GetAppointment(this.repository);
  Future call(int id) => repository.getAppointment(id);
}
