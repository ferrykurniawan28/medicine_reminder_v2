part of '../main.dart';

class Appointment extends StatefulWidget {
  const Appointment({super.key});

  @override
  State<Appointment> createState() => _CalendarState();
}

class _CalendarState extends State<Appointment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: defaultAppBar('Appointment', actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
      ]),
      // body: SfCalendar(
      //   view: CalendarView.schedule,
      //   // controller: _calendarController,
      //   timeSlotViewSettings: const TimeSlotViewSettings(
      //     timeRulerSize: 50,
      //     timeIntervalHeight: 50,
      //   ),
      //   initialSelectedDate: DateTime.now(),
      //   dataSource: MeetingDataSource(_getDataSource()),
      //   scheduleViewMonthHeaderBuilder: (BuildContext buildContext,
      //       ScheduleViewMonthHeaderDetails details) {
      //     final String monthName = DateFormat('MMMM').format(details.date);
      //     return Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Row(
      //         children: [
      //           Text(
      //             monthName,
      //             style: const TextStyle(
      //               fontSize: 18,
      //               fontWeight: FontWeight.bold,
      //             ),
      //           ),
      //         ],
      //       ),
      //     );
      //   },
      //   monthViewSettings: const MonthViewSettings(
      //     appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
      //     showAgenda: true,
      //   ),
      // ),
      body: ListView(
        children: [
          const AppointmentSection(),
        ],
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

// List<Appointment> _getDataSource() {
//   final List<Appointment> appointments = <Appointment>[];
//   final DateTime today = DateTime.now();
//   final DateTime startTime =
//       DateTime(today.year, today.month, today.day, 9, 0, 0);
//   final DateTime endTime = startTime.add(const Duration(hours: 2));
//   appointments.add(Appointment(
//     startTime: startTime,
//     endTime: endTime,
//     subject: 'Meeting',
//     color: Colors.blue,
//     isAllDay: false,
//   ));
//   return appointments;
// }

// List<Appointment> _getDataSource() {
//   final List<Appointment> appointments = <Appointment>[];
//   final DateTime today = DateTime.now();

//   appointments.add(Appointment(
//     startTime: DateTime(today.year, today.month, today.day, 9, 0, 0),
//     endTime: DateTime(today.year, today.month, today.day, 11, 0, 0),
//     subject: 'Doctor Consultation',
//     color: Colors.blue,
//     isAllDay: false,
//   ));

//   appointments.add(Appointment(
//     startTime: DateTime(today.year, today.month, today.day, 9, 0, 0),
//     endTime: DateTime(today.year, today.month, today.day, 11, 0, 0),
//     subject: 'Doctor Consultation',
//     color: Colors.blue,
//     isAllDay: false,
//   ));

//   appointments.add(Appointment(
//     startTime: DateTime(today.year, today.month, today.day, 9, 0, 0),
//     endTime: DateTime(today.year, today.month, today.day, 11, 0, 0),
//     subject: 'Doctor Consultation',
//     color: Colors.green,
//     isAllDay: false,
//   ));

//   appointments.add(Appointment(
//     startTime: DateTime(today.year, today.month, today.day, 9, 0, 0),
//     endTime: DateTime(today.year, today.month, today.day, 11, 0, 0),
//     subject: 'Doctor Consultation',
//     color: Colors.red,
//     isAllDay: false,
//   ));

//   appointments.add(Appointment(
//     startTime: DateTime(today.year, today.month, today.day, 14, 0, 0),
//     endTime: DateTime(today.year, today.month, today.day, 15, 0, 0),
//     subject: 'Medication Reminder',
//     color: Colors.green,
//     isAllDay: false,
//   ));

//   appointments.add(Appointment(
//     startTime: DateTime(today.year, today.month, today.day + 1, 10, 30, 0),
//     endTime: DateTime(today.year, today.month, today.day + 1, 11, 30, 0),
//     subject: 'Check-up with Caregiver',
//     color: Colors.orange,
//     isAllDay: false,
//   ));

//   appointments.add(Appointment(
//     startTime: DateTime(today.year, today.month, today.day + 2, 8, 0, 0),
//     endTime: DateTime(today.year, today.month, today.day + 2, 8, 30, 0),
//     subject: 'Medicine Refill Reminder',
//     color: Colors.red,
//     isAllDay: false,
//   ));

//   return appointments;
// }
