part of '../main.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<ReminderBloc>(context).add(LoadReminders());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(
        'Reminders',
        actions: [
          IconButton(
            onPressed: () {
              Modular.to.pushNamed('/reminder/');
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: const ReminderListBody(),
    );
  }
}
