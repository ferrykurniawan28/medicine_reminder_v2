part of 'reminder_bloc.dart';

sealed class ReminderEvent extends Equatable {
  const ReminderEvent();

  @override
  List<Object> get props => [];
}

final class LoadReminders extends ReminderEvent {}

final class AddReminder extends ReminderEvent {
  final ReminderModel reminder;

  const AddReminder(this.reminder);

  @override
  List<Object> get props => [reminder];
}

final class UpdateReminder extends ReminderEvent {
  final ReminderModel reminder;

  const UpdateReminder(this.reminder);

  @override
  List<Object> get props => [reminder];
}

final class DeleteReminder extends ReminderEvent {
  final int reminderId;

  const DeleteReminder(this.reminderId);

  @override
  List<Object> get props => [reminderId];
}

final class UpdateReminderStatus extends ReminderEvent {
  final ReminderModel reminder;

  const UpdateReminderStatus(this.reminder);

  @override
  List<Object> get props => [reminder];
}
