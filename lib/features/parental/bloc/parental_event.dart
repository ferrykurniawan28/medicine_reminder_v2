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

final class LoadParental extends ParentalEvent {
  final int userId;

  const LoadParental(this.userId);

  @override
  List<Object> get props => [userId];
}

final class AddParental extends ParentalEvent {
  final Parental parental;

  const AddParental(this.parental);

  @override
  List<Object> get props => [parental];
}

final class UpdateParental extends ParentalEvent {
  final Parental parental;

  const UpdateParental(this.parental);

  @override
  List<Object> get props => [parental];
}

final class DeleteParental extends ParentalEvent {
  final int id;

  const DeleteParental(this.id);

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
