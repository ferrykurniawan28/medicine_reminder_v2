part of '../widgets.dart';

void addAppointment(
  BuildContext ctx,
  int toUserId, {
  required Function(Appointment appointment) onSave,
}) {
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay selectedTime = const TimeOfDay(hour: 9, minute: 0);
  String name = '';
  String note = '';

  showModalBottomSheet(
    context: ctx,
    // isScrollControlled: true,
    scrollControlDisabledMaxHeightRatio: 0.9,
    // useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    backgroundColor: Colors.grey[100],
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Column(
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
                        setState(() {
                          selectedDate = newDate;
                        });
                      },
                      onTimeChanged: (TimeOfDay newTime) {
                        setState(() {
                          selectedTime = newTime;
                        });
                      },
                    ),
                    spacerHeight(16),
                    DoctorInputField(
                      onDoctorChanged: (p0) => setState(() => name = p0),
                      onNoteChanged: (p0) => setState(() => note = p0),
                    ),
                    spacerHeight(16),
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
                            ? () async {
                                final userId =
                                    await SharedPreference.getInt('userId');
                                if (!context.mounted) return;

                                final appointment = Appointment(
                                  userAssigned: User(userId: toUserId),
                                  userCreated: User(userId: userId),
                                  doctor: name,
                                  note: note,
                                  time: DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    selectedTime.hour,
                                    selectedTime.minute,
                                  ),
                                );

                                // Use the callback instead of hardcoded bloc
                                onSave(appointment);
                                Navigator.of(context).pop();
                              }
                            : null,
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
