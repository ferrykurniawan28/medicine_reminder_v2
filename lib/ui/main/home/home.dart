part of '../main.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    context.read<ReminderBloc>().add(LoadReminders());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar('Medication', actions: [
        IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Modular.to.pushNamed('/reminder')),
      ]),
      backgroundColor: Colors.white,
      body: BlocBuilder<ReminderBloc, ReminderState>(
        builder: (context, state) {
          if (state is ReminderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReminderLoaded) {
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
      ),
    );
  }
}
