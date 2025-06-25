import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_reminder/features/reminder/bloc/reminder_bloc.dart';
import 'package:medicine_reminder/features/user/bloc/user_bloc.dart';
import 'package:medicine_reminder/helpers/helpers.dart';
import 'package:medicine_reminder/ui/main/widgets/widgets.dart';
import 'package:shimmer/shimmer.dart';

class ReminderListBody extends StatefulWidget {
  const ReminderListBody({super.key});

  @override
  State<ReminderListBody> createState() => _ReminderListBodyState();
}

class _ReminderListBodyState extends State<ReminderListBody> {
  late final int userId;

  @override
  void initState() {
    final userState = context.read<UserBloc>().state;
    if (userState is CurrentUser) {
      userId = userState.user.userId!;
    } else if (userState is UserLoaded) {
      userId = userState.user.userId!;
    } else {
      userId = 0; // Default to 0 or handle accordingly
      // Handle the case where the user is not logged in or userId is not available
      // return const Center(child: Text('No user is currently logged in.'));
    }
    print('User ID in ReminderListBody: $userId');
    // Trigger the initial load of reminders
    BlocProvider.of<ReminderBloc>(context).add(LoadReminders(userId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ReminderBloc>().add(LoadReminders(userId));
      },
      child: BlocConsumer<ReminderBloc, ReminderState>(
        listener: (context, state) {
          // No need for setState here, the builder will be called automatically
        },
        builder: (context, state) {
          if (state is ReminderLoading) {
            return ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 14,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 100,
                                  height: 12,
                                  color: Colors.grey.shade300,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else if (state is ReminderLoaded) {
            if (state.reminders.isEmpty) {
              return const Center(
                  child: Text(
                'You have no reminders yet, add one!',
                // style: subtitleTextStyle,
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('Failed to load reminders'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ReminderBloc>().add(LoadReminders(userId));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
