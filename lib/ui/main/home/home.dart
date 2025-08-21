part of '../main.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const ReminderListBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final user = UserHelper.getCurrentUser(context);
          Modular.to.pushNamed('/reminder/', arguments: {
            'assignedUser': user,
          });
        },
        backgroundColor: kPrimaryColor,
        shape: const CircleBorder(
          side: BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
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
