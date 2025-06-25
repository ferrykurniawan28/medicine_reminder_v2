part of '../main.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const ReminderListBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final userState = context.read<UserBloc>().state;
          User? user;
          if (userState is CurrentUser) {
            user = userState.user;
          } else if (userState is UserLoaded) {
            user = userState.user;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No user is currently logged in.'),
              ),
            );
            return;
          }
          Modular.to.pushNamed('/reminder/', arguments: {
            'assignedUser': user,
          });
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
