part of '../main.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const ReminderListBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Modular.to.pushNamed('/reminder/');
        },
        backgroundColor: kPrimaryColor,
        shape: const CircleBorder(),
        tooltip: 'Add Reminder',
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
