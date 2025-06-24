part of 'reminder_bloc.dart';

sealed class ReminderEvent extends Equatable {
  const ReminderEvent();

  @override
  List<Object> get props => [];
}

final class LoadReminders extends ReminderEvent {
  final int userId;

  const LoadReminders(this.userId);

  @override
  List<Object> get props => [userId];
}

final class AddReminder extends ReminderEvent {
  final Reminder reminder;

  const AddReminder(this.reminder);

  @override
  List<Object> get props => [reminder];
}

final class UpdateReminder extends ReminderEvent {
  final Reminder reminder;

  const UpdateReminder(this.reminder);

  @override
  List<Object> get props => [reminder];
}

final class DeleteReminder extends ReminderEvent {
  final Reminder reminder;

  const DeleteReminder(this.reminder);

  @override
  List<Object> get props => [reminder];
}

final class UpdateReminderStatus extends ReminderEvent {
  final Reminder reminder;

  const UpdateReminderStatus(this.reminder);

  @override
  List<Object> get props => [reminder];
}
