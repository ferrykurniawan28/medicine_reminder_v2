part of '../widgets.dart';

class AppointmentList extends StatefulWidget {
  final Parental parental;
  const AppointmentList({super.key, required this.parental});

  @override
  State<AppointmentList> createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    context
        .read<ParentalBloc>()
        .add(LoadAppointmentParental(widget.parental.user.userId!));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadAppointments,
      child: Stack(
        children: [
          BlocBuilder<ParentalBloc, ParentalState>(
            builder: (context, state) {
              if (state is AppointmentParentalLoaded) {
                if (state.appointments == null || state.appointments!.isEmpty) {
                  return const Center(
                    child: Text('No appointments found add one!'),
                  );
                }
                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 50, horizontal: 8),
                  itemCount: state.appointments!.length,
                  itemBuilder: (context, index) {
                    final appointment = state.appointments![index];
                    return appointmentCard(context, appointment: appointment);
                  },
                );
              } else if (state is ParentalLoading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return const Center(child: Text('No appointments found'));
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
                addAppointment(context, widget.parental.id!,
                    onSave: (appointment) {
                  // Dispatch the add appointment event
                  context.read<ParentalBloc>().add(CreateParentalAppointment(
                      appointment, widget.parental.id!));
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
