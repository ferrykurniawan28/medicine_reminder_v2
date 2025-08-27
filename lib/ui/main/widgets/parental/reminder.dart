part of '../widgets.dart';

class ReminderList extends StatefulWidget {
  final Parental parental;
  const ReminderList({super.key, required this.parental});

  @override
  State<ReminderList> createState() => _ReminderListState();
}

class _ReminderListState extends State<ReminderList> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    setState(() {
      _isLoading = true;
    });
    context
        .read<ParentalBloc>()
        .add(LoadReminderParental(widget.parental.user.userId!));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadReminders,
      child: Stack(
        children: [
          BlocBuilder<ParentalBloc, ParentalState>(
            builder: (context, state) {
              if (state is ReminderParentalLoaded) {
                if (state.reminders == null || state.reminders!.isEmpty) {
                  return const Center(
                    child: Text('No reminders found add one!'),
                  );
                }
                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 50, horizontal: 8),
                  itemCount: state.reminders?.length ?? 0,
                  itemBuilder: (context, index) {
                    final reminder = state.reminders![index];
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
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              onPressed: () {
                // Handle add reminder action
                // final user = UserHelper.getCurrentUser(context);
                Modular.to.pushNamed('/reminder/', arguments: {
                  'assignedUser': widget.parental.user,
                  'isParental': true,
                });
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
