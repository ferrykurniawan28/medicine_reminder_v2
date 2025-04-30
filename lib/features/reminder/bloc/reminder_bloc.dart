import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medicine_reminder/features/features.dart';
import 'package:medicine_reminder/models/models.dart';

part 'reminder_event.dart';
part 'reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  List<Reminder> reminders = [];
  Reminder? selectedReminder;
  ReminderBloc() : super(ReminderInitial()) {
    on<LoadReminders>(_onFetchReminders);
    // on<LoadReminder>(_onFetchReminder);
    on<AddReminder>(_addReminder);
    on<UpdateReminder>(_updateReminder);
    on<DeleteReminder>(_deleteReminder);
    on<UpdateReminderStatus>(_updateReminderStatus);
  }

  Future<void> _onFetchReminders(
      LoadReminders event, Emitter<ReminderState> emit) async {
    emit(ReminderLoading());
    try {
      reminders = dummyReminders;
      // final reminders = await _reminderRepository.getReminders();
      emit(ReminderLoaded(reminders));
    } catch (e) {
      emit(ReminderError(e.toString()));
    }
  }

  // Future<void> _onFetchReminder(
  //     LoadReminders event, Emitter<ReminderState> emit) async {
  //   emit(ReminderLoading());
  //   try {
  //     selectedReminder = reminders.firstWhere((element) => element.id == event.id);
  //     // final reminder = await _reminderRepository.getReminder(event.id);
  //     emit(ReminderLoaded(selectedReminder!));
  //   } catch (e) {
  //     emit(ReminderError(e.toString()));
  //   }
  // }

  Future<void> _addReminder(
      AddReminder event, Emitter<ReminderState> emit) async {
    emit(ReminderLoading());
    // TODO: Uncomment when reminder repository is available
    final newReminder = event.reminder.copyWith(
        // deviceId: context.read<DeviceBloc>().device?.id,
        // userId: context.read<UserBloc>().user?.id,
        );
    try {
      // await _reminderRepository.addReminder(event.reminder);
      reminders.add(newReminder);
      // emit(ReminderAdded(event.reminder));
      emit(ReminderLoaded(reminders));
    } catch (e) {
      emit(ReminderError(e.toString()));
    }
  }

  Future<void> _updateReminder(
      UpdateReminder event, Emitter<ReminderState> emit) async {
    emit(ReminderLoading());
    try {
      final index =
          reminders.indexWhere((reminder) => reminder.id == event.reminder.id);
      if (index != -1) {
        reminders[index] = event.reminder;
        // await _reminderRepository.updateReminder(event.reminder);
        // emit(ReminderUpdated(event.reminder));
        emit(ReminderLoaded(reminders));
      }
    } catch (e) {
      emit(ReminderError(e.toString()));
    }
  }

  Future<void> _updateReminderStatus(
      UpdateReminderStatus event, Emitter<ReminderState> emit) async {
    emit(ReminderLoading());
    try {
      final index =
          reminders.indexWhere((reminder) => reminder.id == event.reminderId);
      if (index != -1) {
        Reminder reminder = reminders[index].copyWith(isActive: event.isActive);
        reminders[index] = reminder;
        // await _reminderRepository.updateReminder(reminder);
        emit(ReminderLoaded(reminders));
      }
    } catch (e) {
      emit(ReminderError(e.toString()));
    }
  }

  Future<void> _deleteReminder(
      DeleteReminder event, Emitter<ReminderState> emit) async {
    emit(ReminderLoading());
    try {
      reminders.removeWhere((reminder) => reminder.id == event.reminderId);
      // await _reminderRepository.deleteReminder(event.reminderId);
      emit(ReminderDeleted(event.reminderId));
    } catch (e) {
      emit(ReminderError(e.toString()));
    }
  }
}
