import '../repositories/appointment_repository.dart';

class GetAppointments {
  final AppointmentRepository repository;
  GetAppointments(this.repository);
  Future<List> call() => repository.getAppointments();
}
