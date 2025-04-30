part of 'appointment_bloc.dart';

sealed class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object> get props => [];
}

final class AppointmentsFetch extends AppointmentEvent {
  final int userId;

  const AppointmentsFetch(this.userId);

  @override
  List<Object> get props => [userId];
}

final class AppointmentFetch extends AppointmentEvent {
  final int id;

  const AppointmentFetch(this.id);

  @override
  List<Object> get props => [id];
}

final class AppointmentAdd extends AppointmentEvent {
  final Appointment appointment;

  const AppointmentAdd(this.appointment);

  @override
  List<Object> get props => [appointment];
}

final class AppointmentUpdate extends AppointmentEvent {
  final Appointment appointment;

  const AppointmentUpdate(this.appointment);

  @override
  List<Object> get props => [appointment];
}

final class AppointmentDelete extends AppointmentEvent {
  final Appointment appointment;

  const AppointmentDelete(this.appointment);

  @override
  List<Object> get props => [appointment];
}
