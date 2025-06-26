part of '../main.dart';

class Appointment extends StatefulWidget {
  const Appointment({super.key});

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  bool _isFetching = false; // Add a flag to prevent duplicate fetches
  bool _hasInitialized = false; // Track if we've already initialized

  @override
  void initState() {
    super.initState();
    // Move context-dependent code to didChangeDependencies or addPostFrameCallback
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitialized) {
      _hasInitialized = true;
      // Use addPostFrameCallback to ensure the widget tree is fully built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchAppointments();
      });
    }
  }

  void _fetchAppointments() {
    if (_isFetching || !mounted) {
      return;
    }

    _isFetching = true; // Set fetching flag to true

    try {
      final userState = context.read<UserBloc>().state;
      if (userState is CurrentUser) {
        final userId = userState.user.userId; // Access userId from CurrentUser
        context.read<AppointmentBloc>().add(AppointmentsFetch(userId!));
      } else if (userState is UserLoaded) {
        final userId = userState.user.userId; // Access userId from UserLoaded
        context.read<AppointmentBloc>().add(AppointmentsFetch(userId!));
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No user is currently logged in.'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching appointments: $e'),
          ),
        );
      }
    } finally {
      _isFetching = false; // Reset fetching flag
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AppointmentBloc, AppointmentState>(
        listener: (context, state) {
          // Handle side effects like showing errors
          if (state is AppointmentError &&
              state.message != 'No appointments found') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return _buildContent(state);
        },
      ),
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

  Widget _buildContent(AppointmentState state) {
    if (state is AppointmentLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is AppointmentsLoaded) {
      if (state.appointments.isEmpty) {
        return const _EmptyAppointmentsList();
      }
      return _AppointmentsList(
        appointments: state.appointments,
        onRefresh: _fetchAppointments,
      );
    } else if (state is AppointmentError) {
      if (state.message == 'No appointments found') {
        return const _EmptyAppointmentsList();
      }
      return _AppointmentErrorView(
        message: state.message,
        onRetry: _fetchAppointments,
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}

class _EmptyAppointmentsList extends StatelessWidget {
  const _EmptyAppointmentsList();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'You have no appointments yet, add one!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentsList extends StatelessWidget {
  final List<dynamic> appointments;
  final VoidCallback onRefresh;

  const _AppointmentsList({
    required this.appointments,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        itemCount: appointments.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return RepaintBoundary(
            key: ValueKey(appointment.id), // Move key to RepaintBoundary
            child: appointmentCard(
              context,
              appointment: appointment,
            ),
          );
        },
      ),
    );
  }
}

class _AppointmentErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _AppointmentErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
