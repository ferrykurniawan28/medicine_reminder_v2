part of '../widgets.dart';

class ReminderList extends StatefulWidget {
  final Parental parental;
  const ReminderList({super.key, required this.parental});

  @override
  State<ReminderList> createState() => _ReminderListState();
}

class _ReminderListState extends State<ReminderList> {
  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    context.read<ParentalBloc>().add(
        const LoadReminderParental(1)); //Todo: get the id from the parental
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadReminders,
      child: BlocBuilder<ParentalBloc, ParentalState>(
        builder: (context, state) {
          if (state is ReminderParentalLoaded) {
            if (state.reminders.isEmpty) {
              return const Center(
                child: Text('No reminders found add one!'),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: state.reminders.length,
              itemBuilder: (context, index) {
                final reminder = state.reminders[index];
                return CardReminder(reminder: reminder);
              },
            );
          } else if (state is ParentalLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('No reminders found'));
          }
        },
      ),
    );
  }
}
