import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_reminder/features/reminder/bloc/reminder_bloc.dart';
import 'package:medicine_reminder/helpers/helpers.dart';
import 'package:medicine_reminder/ui/main/widgets/widgets.dart';

class ReminderListBody extends StatelessWidget {
  const ReminderListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReminderBloc, ReminderState>(
      listener: (context, state) {
        // No need for setState here, the builder will be called automatically
      },
      builder: (context, state) {
        if (state is ReminderLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ReminderLoaded) {
          if (state.reminders.isEmpty) {
            return Center(
                child: Text(
              'You have no reminders yet, add one!',
              style: subtitleTextStyle,
            ));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: state.reminders.length,
            itemBuilder: (context, index) {
              return CardReminder(reminder: state.reminders[index]);
            },
          );
        } else if (state is ReminderError) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text('No reminders found'));
        }
      },
    );
  }
}
