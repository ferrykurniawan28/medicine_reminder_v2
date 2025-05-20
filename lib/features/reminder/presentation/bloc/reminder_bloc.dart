// // This file is deprecated. Please use lib/features/reminder/bloc/reminder_bloc.dart instead.

// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:medicine_reminder/features/reminder/domain/entities/reminder.dart';
// import 'package:medicine_reminder/features/reminder/domain/usecases/get_reminders.dart';
// import 'package:medicine_reminder/features/reminder/domain/usecases/add_reminder.dart';
// import 'package:medicine_reminder/features/reminder/domain/usecases/delete_reminder.dart';

// part 'reminder_event.dart';
// part 'reminder_state.dart';

// class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
//   final GetReminders getReminders;
//   final AddReminder addReminder;
//   final DeleteReminder deleteReminder;

//   ReminderBloc({
//     required this.getReminders,
//     required this.addReminder,
//     required this.deleteReminder,
//   }) : super(ReminderInitial()) {
//     on<LoadRemindersEvent>((event, emit) async {
//       emit(ReminderLoading());
//       final reminders = await getReminders();
//       emit(ReminderLoaded(reminders));
//     });

//     on<AddReminderEvent>((event, emit) async {
//       await addReminder(event.reminder);
//       add(LoadRemindersEvent());
//     });

//     on<DeleteReminderEvent>((event, emit) async {
//       await deleteReminder(event.id);
//       add(LoadRemindersEvent());
//     });
//   }
// }
