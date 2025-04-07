part of '../main.dart';

class Appointment extends StatefulWidget {
  const Appointment({super.key});

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  @override
  void initState() {
    super.initState();
    context.read<AppointmentBloc>().add(const AppointmentsFetch(1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: defaultAppBar('Appointment', actions: [
        IconButton(
            onPressed: () => addAppointment(context),
            icon: const Icon(Icons.add)),
      ]),
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
          return Center(child: Text(state.message));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }
}
