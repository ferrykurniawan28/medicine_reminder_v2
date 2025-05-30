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
import 'package:medicine_reminder/features/reminder/data/repositories/reminder_repository_impl.dart';

part 'reminder_event.dart';
part 'reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final GetReminders getReminders;
  final usecase_add.AddReminder addReminder;
  final usecase_delete.DeleteReminder deleteReminder;
  final usecase_update.UpdateReminder updateReminder;

  ReminderBloc()
      : getReminders = GetReminders(ReminderRepositoryImpl()),
        addReminder = usecase_add.AddReminder(ReminderRepositoryImpl()),
        deleteReminder =
            usecase_delete.DeleteReminder(ReminderRepositoryImpl()),
        updateReminder =
            usecase_update.UpdateReminder(ReminderRepositoryImpl()),
        super(ReminderInitial()) {
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
      print(reminders.map((r) => r.toJson()).toList());
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
      print(event.reminder.toJson());
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
    try {
      await updateReminder.call(event.reminder);
      if (state is ReminderLoaded) {
        final currentReminders = (state as ReminderLoaded).reminders;
        final updatedReminders = currentReminders
            .map((r) => r.id == event.reminder.id ? event.reminder : r)
            .toList();
        emit(ReminderLoaded(updatedReminders));
      }
    } catch (e) {
      emit(ReminderError(e.toString()));
    }
  }
}
