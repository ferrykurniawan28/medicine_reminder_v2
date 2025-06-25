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
import 'package:medicine_reminder/features/reminder/domain/usecases/update_reminder_status.dart'
    as usecase_status;

part 'reminder_event.dart';
part 'reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  List<Reminder> reminders = [];
  final GetReminders getReminders;
  final usecase_add.AddReminder addReminder;
  final usecase_delete.DeleteReminder deleteReminder;
  final usecase_update.UpdateReminder updateReminder;
  final ReminderRepositoryImpl reminderRepository;
  final usecase_status.UpdateReminderStatus updateReminderStatus;

  ReminderBloc({required this.reminderRepository})
      : getReminders = GetReminders(reminderRepository),
        addReminder = usecase_add.AddReminder(reminderRepository),
        deleteReminder = usecase_delete.DeleteReminder(reminderRepository),
        updateReminder = usecase_update.UpdateReminder(reminderRepository),
        updateReminderStatus =
            usecase_status.UpdateReminderStatus(reminderRepository),
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
      reminders = await getReminders(event.userId);
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
      reminders.add(newReminder);
      emit(ReminderLoaded(reminders));
      // emit(ReminderAdded(newReminder));
      // add(LoadReminders(event.reminder.assignedTo!.userId!));
    } catch (e) {
      emit(ReminderError(e.toString()));
    }
  }

  Future<void> _deleteReminder(
      DeleteReminder event, Emitter<ReminderState> emit) async {
    emit(ReminderLoading());
    try {
      await deleteReminder.call(event.reminder.id!);
      reminders.removeWhere((reminder) => reminder.id == event.reminder.id);
      emit(ReminderLoaded(reminders));
      // emit(ReminderDeleted(event.reminderId));
      // add(LoadReminders(event.userId));
    } catch (e) {
      emit(ReminderError(e.toString()));
    }
  }

  Future<void> _updateReminder(
      UpdateReminder event, Emitter<ReminderState> emit) async {
    emit(ReminderLoading());
    try {
      await updateReminder.call(event.reminder);
      add(LoadReminders(event.reminder.assignedTo!.userId!));
    } catch (e) {
      emit(ReminderError(e.toString()));
    }
  }

  Future<void> _updateReminderStatus(
      UpdateReminderStatus event, Emitter<ReminderState> emit) async {
    try {
      // Find the index of the reminder to update
      final index =
          reminders.indexWhere((reminder) => reminder.id == event.reminder.id);
      if (index == -1) {
        throw Exception('Reminder not found');
      }

      // Update the isActive status directly in the reminders list
      // reminders[index] =
      //     reminders[index].copyWith(isActive: event.reminder.isActive);

      // Directly update the reminder in the repository
      final updatedReminder = reminders[index].copyWith(
        isActive: event.reminder.isActive,
      );
      await updateReminderStatus.call(updatedReminder);

      // Update the reminders list with the modified reminder
      // reminders[index] = updatedReminder;

      // // Emit the updated reminders list
      // emit(ReminderLoaded(reminders));
    } catch (e) {
      print('Error updating reminder status: $e');
      emit(ReminderError(e.toString()));
    }
  }
}
