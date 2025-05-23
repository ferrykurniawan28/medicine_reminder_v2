part of 'parental_bloc.dart';

sealed class ParentalState extends Equatable {
  const ParentalState();

  @override
  List<Object> get props => [];
}

final class ParentalInitial extends ParentalState {}

final class ParentalListLoading extends ParentalState {}

final class ParentalLoading extends ParentalState {}

final class ParentalsLoaded extends ParentalState {
  final List<Parental> parentals;

  const ParentalsLoaded(this.parentals);

  @override
  List<Object> get props => [parentals];
}

final class ParentalLoaded extends ParentalState {
  final Parental parental;

  const ParentalLoaded(this.parental);

  @override
  List<Object> get props => [parental];
}

final class ParentalError extends ParentalState {
  final String message;

  const ParentalError(this.message);

  @override
  List<Object> get props => [message];
}

final class ReminderParentalLoaded extends ParentalState {
  final List<ReminderModel> reminders;

  const ReminderParentalLoaded(this.reminders);

  @override
  List<Object> get props => [reminders];
}

final class AppointmentParentalLoaded extends ParentalState {
  final List<Appointment> appointments;

  const AppointmentParentalLoaded(this.appointments);

  @override
  List<Object> get props => [appointments];
}

final class DeviceParentalLoaded extends ParentalState {
  final Device devices;

  const DeviceParentalLoaded(this.devices);

  @override
  List<Object> get props => [devices];
}
