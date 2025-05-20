import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medicine_reminder/features/reminder/data/models/reminder_model.dart';
import 'package:medicine_reminder/features/reminder/domain/usecases/get_reminders.dart';
import 'package:medicine_reminder/features/reminder/domain/usecases/add_reminder.dart'
    as usecase_add;
import 'package:medicine_reminder/features/reminder/domain/usecases/delete_reminder.dart'
    as usecase_delete;
import 'package:medicine_reminder/features/reminder/domain/usecases/update_reminder.dart'
    as usecase_update;
import 'package:medicine_reminder/features/reminder/data/repositories/reminder_repository_impl.dart'
    show domainToApp, appToDomain;

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
      final domainReminders = await getReminders();
      // id is always int in domain entity now
      final appReminders = domainReminders.map(domainToApp).toList();
      print(
          'Fetched reminders: ${appReminders.map((r) => r.toJson()).toList()}');
      emit(ReminderLoaded(appReminders));
    } catch (e) {
      emit(ReminderError(e.toString()));
    }
  }

  Future<void> _addReminder(
      AddReminder event, Emitter<ReminderState> emit) async {
    emit(ReminderLoading());
    try {
      final domainReminder = appToDomain(event.reminder);
      await addReminder.call(domainReminder);
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

  // TODO: Refactor update and status logic to use repository/use cases
  Future<void> _updateReminder(
      UpdateReminder event, Emitter<ReminderState> emit) async {
    emit(ReminderLoading());
    // TODO: Implement update logic using repository/use case
    emit(ReminderError('Update not implemented in clean architecture yet.'));
  }

  Future<void> _updateReminderStatus(
      UpdateReminderStatus event, Emitter<ReminderState> emit) async {
    emit(ReminderLoading());
    try {
      final domainReminder = appToDomain(event.reminder);
      await updateReminder.call(domainReminder);
      add(LoadReminders());
    } catch (e) {
      emit(ReminderError(e.toString()));
    }
  }
}
