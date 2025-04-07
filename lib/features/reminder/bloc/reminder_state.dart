part of 'reminder_bloc.dart';

sealed class ReminderState extends Equatable {
  const ReminderState();

  @override
  List<Object> get props => [];
}

final class ReminderInitial extends ReminderState {}

final class ReminderLoading extends ReminderState {}

final class ReminderLoaded extends ReminderState {
  final List<Reminder> reminders;

  const ReminderLoaded(this.reminders);

  @override
  List<Object> get props => [reminders];
}

final class ReminderError extends ReminderState {
  final String message;

  const ReminderError(this.message);

  @override
  List<Object> get props => [message];
}

final class ReminderUpdated extends ReminderState {
  final Reminder reminder;

  const ReminderUpdated(this.reminder);

  @override
  List<Object> get props => [reminder];
}

final class ReminderDeleted extends ReminderState {
  final int reminderId;

  const ReminderDeleted(this.reminderId);

  @override
  List<Object> get props => [reminderId];
}

final class ReminderAdded extends ReminderState {
  final Reminder reminder;

  const ReminderAdded(this.reminder);

  @override
  List<Object> get props => [reminder];
}

final class ReminderUpdatedStatus extends ReminderState {
  final int reminderId;
  final bool isActive;

  const ReminderUpdatedStatus(this.reminderId, this.isActive);

  @override
  List<Object> get props => [reminderId, isActive];
}
