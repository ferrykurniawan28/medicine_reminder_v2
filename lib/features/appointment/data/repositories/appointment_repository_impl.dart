import '../../domain/entities/appointment.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../datasources/appointment_local_datasource.dart';
import '../models/appointment_model.dart';
import 'package:medicine_reminder/features/doctor/data/models/doctor_model.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentLocalDataSource localDataSource;
  AppointmentRepositoryImpl(this.localDataSource);

  @override
  Future<List<Appointment>> getAppointments() async {
    return await localDataSource.getAppointments();
  }

  @override
  Future<Appointment?> getAppointment(int id) async {
    return await localDataSource.getAppointment(id);
  }

  @override
  Future<void> addAppointment(Appointment appointment) async {
    final model = AppointmentModel(
      id: appointment.id,
      user: appointment.user,
      doctor: DoctorModel(
        id: appointment.doctor.id,
        name: appointment.doctor.name,
        speciality: appointment.doctor.speciality,
        street: appointment.doctor.street,
        zipCode: appointment.doctor.zipCode,
        city: appointment.doctor.city,
        phone: appointment.doctor.phone,
        email: appointment.doctor.email,
        website: appointment.doctor.website,
      ),
      note: appointment.note,
      time: appointment.time,
    );
    await localDataSource.addAppointment(model);
  }

  @override
  Future<void> updateAppointment(Appointment appointment) async {
    final model = AppointmentModel(
      id: appointment.id,
      user: appointment.user,
      doctor: DoctorModel(
        id: appointment.doctor.id,
        name: appointment.doctor.name,
        speciality: appointment.doctor.speciality,
        street: appointment.doctor.street,
        zipCode: appointment.doctor.zipCode,
        city: appointment.doctor.city,
        phone: appointment.doctor.phone,
        email: appointment.doctor.email,
        website: appointment.doctor.website,
      ),
      note: appointment.note,
      time: appointment.time,
    );
    await localDataSource.updateAppointment(model);
  }

  @override
  Future<void> deleteAppointment(int id) async {
    await localDataSource.deleteAppointment(id);
  }
}
