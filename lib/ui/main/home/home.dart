part of '../main.dart';

//TODO: fix this import path
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isFetching = false;
  int? userId;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchReminders();
    });
  }

  Future<void> _fetchReminders() async {
    if (_isFetching) return;

    setState(() {
      _isFetching = true;
      _hasError = false;
    });

    try {
      userId = await SharedPreference.getInt('userId');

      if (userId == null) {
        setState(() => _hasError = true);
        return;
      }

      if (!mounted) return;
      context.read<ReminderBloc>().add(LoadReminders(userId!));
    } catch (e) {
      if (!mounted) return;
      setState(() => _hasError = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching reminders: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isFetching = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: defaultAppBar(
      //   'Reminders',
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         Modular.to.pushNamed('/reminder/');
      //       },
      //       icon: const Icon(Icons.add),
      //     ),
      //   ],
      // ),
      body: _isFetching
          ? const CircularProgressIndicator()
          : _hasError || userId == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text('Failed to load reminders'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchReminders,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : ReminderListBody(userId: userId!),
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
