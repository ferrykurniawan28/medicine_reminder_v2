import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medicine_reminder/features/reminder/domain/entities/reminder.dart';
import 'package:medicine_reminder/features/reminder/domain/usecases/get_reminders.dart';
import 'package:medicine_reminder/features/reminder/domain/usecases/add_reminder.dart'
    as usecase_add;
import 'package:medicine_reminder/features/reminder/domain/usecases/delete_reminder.dart'
    as usecase_delete;
import 'package:medicine_reminder/features/reminder/domain/usecases/update_reminder.dart'
    as usecase_update;

part 'reminder_event.dart';
part 'reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final GetReminders getReminders;
  final usecase_add.AddReminder addReminder;
  final usecase_delete.DeleteReminder deleteReminder;
  final usecase_update.UpdateReminder updateReminder;

  ReminderBloc({
    required this.getReminders,
    required this.addReminder,
    required this.deleteReminder,
    required this.updateReminder,
  }) : super(ReminderInitial()) {
    on<LoadReminders>(_onFetchReminders);
    on<AddReminder>(_addReminder);
    on<UpdateReminder>(_updateReminder);
    on<DeleteReminder>(_deleteReminder);
    on<UpdateReminderStatus>(_updateReminderStatus);
  }

  Future<void> _onFetchReminders(
      LoadReminders event, Emitter<ReminderState> emit) async {
    emit(ReminderLoading());
    try {
      final reminders = await getReminders();
      emit(ReminderLoaded(reminders));
    } catch (e) {
      print('Error fetching reminders: $e');
      emit(ReminderError(e.toString()));
    }
  }

  Future<void> _addReminder(
      AddReminder event, Emitter<ReminderState> emit) async {
    emit(ReminderLoading());
    try {
      final newReminder = await addReminder.call(event.reminder);
      emit(ReminderAdded(newReminder));
      add(LoadReminders());
    } catch (e) {
      emit(ReminderError(e.toString()));
    }
  }

  Future<void> _deleteReminder(
      DeleteReminder event, Emitter<ReminderState> emit) async {
    emit(ReminderLoading());
    try {
      await deleteReminder.call(event.reminderId);
      emit(ReminderDeleted(event.reminderId));
      add(LoadReminders());
    } catch (e) {
      emit(ReminderError(e.toString()));
    }
  }

  Future<void> _updateReminder(
      UpdateReminder event, Emitter<ReminderState> emit) async {
    emit(ReminderLoading());
    try {
      await updateReminder.call(event.reminder);
      add(LoadReminders());
    } catch (e) {
      emit(ReminderError(e.toString()));
    }
  }

  Future<void> _updateReminderStatus(
      UpdateReminderStatus event, Emitter<ReminderState> emit) async {
    emit(ReminderLoading());
    try {
      await updateReminder.call(event.reminder);
      add(LoadReminders());
    } catch (e) {
      emit(ReminderError(e.toString()));
    }
  }
}
