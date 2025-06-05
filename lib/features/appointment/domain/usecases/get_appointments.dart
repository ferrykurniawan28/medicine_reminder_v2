import 'package:medicine_reminder/features/appointment/domain/entities/appointment.dart';

import '../repositories/appointment_repository.dart';

class GetAppointments {
  final AppointmentRepository repository;
  GetAppointments(this.repository);
  Future<List<Appointment>> call(int userId) =>
      repository.getAppointments(userId);
}
