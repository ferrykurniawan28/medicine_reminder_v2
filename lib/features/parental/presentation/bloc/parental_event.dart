part of 'parental_bloc.dart';

sealed class ParentalEvent extends Equatable {
  const ParentalEvent();

  @override
  List<Object> get props => [];
}

final class LoadParentals extends ParentalEvent {
  final int userId;

  const LoadParentals(this.userId);

  @override
  List<Object> get props => [userId];
}

final class ParentalAdd extends ParentalEvent {
  final Parental parental;
  final int userId;

  const ParentalAdd(this.parental, this.userId);

  @override
  List<Object> get props => [parental, userId];
}

final class ParentalUpdate extends ParentalEvent {
  final Parental parental;

  const ParentalUpdate(this.parental);

  @override
  List<Object> get props => [parental];
}

final class ParentalDelete extends ParentalEvent {
  final int id;

  const ParentalDelete(this.id);

  @override
  List<Object> get props => [id];
}

final class LoadReminderParental extends ParentalEvent {
  final int parentalId;

  const LoadReminderParental(this.parentalId);

  @override
  List<Object> get props => [parentalId];
}

final class LoadAppointmentParental extends ParentalEvent {
  final int parentalId;

  const LoadAppointmentParental(this.parentalId);

  @override
  List<Object> get props => [parentalId];
}

final class LoadDeviceParental extends ParentalEvent {
  final int parentalId;

  const LoadDeviceParental(this.parentalId);

  @override
  List<Object> get props => [parentalId];
}

final class CreateParentalAppointment extends ParentalEvent {
  final Appointment appointment;
  final int parentalId;

  const CreateParentalAppointment(this.appointment, this.parentalId);

  @override
  List<Object> get props => [appointment, parentalId];
}

final class CreateParentalReminder extends ParentalEvent {
  final Reminder reminder;
  final int parentalId;

  const CreateParentalReminder(this.reminder, this.parentalId);

  @override
  List<Object> get props => [reminder, parentalId];
}
