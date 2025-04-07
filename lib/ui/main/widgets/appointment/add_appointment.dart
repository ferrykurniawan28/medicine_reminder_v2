part of '../widgets.dart';

void addAppointment(BuildContext ctx) {
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay selectedTime = const TimeOfDay(hour: 9, minute: 0);
  String name = '';
  String note = '';

  showModalBottomSheet(
    context: ctx,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    backgroundColor: Colors.grey[100],
    builder: (BuildContext context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    boxShadow: [
                      defaultShadow,
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Add Appointment',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CupertinoButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  spacerHeight(16),
                  SelectDateTime(
                    selectDateTime: DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    ),
                    onDateChanged: (DateTime newDate) {
                      selectedDate = newDate;
                    },
                    onTimeChanged: (TimeOfDay newTime) {
                      selectedTime = newTime;
                    },
                  ),
                  spacerHeight(16),
                  DoctorInputField(
                    onDoctorChanged: (p0) => name = p0,
                    onNoteChanged: (p0) => note = p0,
                  ),
                  spacerHeight(16),
                  // CupertinoSlidingSegmentedControl(
                  //     children: {
                  //       0: const Text('For You'),
                  //       1: const Text('For Group'),
                  //     },
                  //     onValueChanged: (int? newValue) {
                  //       print(newValue);
                  //     }),
                  // spacerHeight(16),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Reminders', style: bodyTextStyle),
                        spacerHeight(8),
                        Text(
                          'Two default reminders will be automatically set for your appointment: one for 6 PM the day before, and the other 2 hours before the appointment.',
                          style: captionTextStyle.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  spacerHeight(16),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: name != ''
                          ? () {
                              context.read<AppointmentBloc>().add(
                                    AppointmentAdd(
                                      Appointment(
                                        user: User(
                                            userId: 1,
                                            userName: 'Abraham Lincoln'),
                                        doctor: Doctor(name: name),
                                        note: note,
                                        time: DateTime(
                                          selectedDate.year,
                                          selectedDate.month,
                                          selectedDate.day,
                                          selectedTime.hour,
                                          selectedTime.minute,
                                        ),
                                      ),
                                    ),
                                  );
                              context
                                  .read<AppointmentBloc>()
                                  .add(const AppointmentsFetch(1));
                              Navigator.of(context).pop();
                            }
                          : null,
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.resolveWith<Color?>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.disabled)) {
                              return Colors.grey;
                            }
                            return softBlueColor;
                          },
                        ),
                      ),
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
