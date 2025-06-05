part of '../main.dart';

class Appointment extends StatefulWidget {
  const Appointment({super.key});

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  bool _isFetching = false; // Add a flag to prevent duplicate fetches

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    if (_isFetching) {
      print('Fetch already in progress, skipping duplicate call.');
      return;
    }

    _isFetching = true; // Set fetching flag to true

    try {
      final userId = await SharedPreference.getInt('userId');
      print('Fetching appointments for userId: $userId');

      if (userId == null) {
        print('User ID is null, cannot fetch appointments');
        return;
      }

      if (!mounted) return;

      context.read<AppointmentBloc>().add(AppointmentsFetch(userId));
    } catch (e) {
      print('Error fetching appointments: $e');
    } finally {
      _isFetching = false; // Reset fetching flag
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: defaultAppBar('Appointment', actions: [
      //   IconButton(
      //       onPressed: () => addAppointment(context),
      //       icon: const Icon(Icons.add)),
      // ]),
      body: BlocBuilder<AppointmentBloc, AppointmentState>(
          builder: (context, state) {
        if (state is AppointmentsLoaded) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            itemCount: state.appointments.length,
            itemBuilder: (context, index) {
              final appointment = state.appointments[index];
              return appointmentCard(context, appointment: appointment);
            },
          );
        } else if (state is AppointmentLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AppointmentError) {
          if (state.message == 'No appointments found') {
            return const Center(
                child: Text('You have no appointments yet, add one!'));
          }
          return Center(
              child: Column(
            children: [
              Text(state.message),
            ],
          ));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addAppointment(context),
        backgroundColor: kPrimaryColor,
        shape: const CircleBorder(),
        tooltip: 'Add Appointment',
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
