part of '../widgets.dart';

void editAppointment(BuildContext ctx, Appointment appointment) {
  DateTime selectedDate = appointment.time;
  TimeOfDay selectedTime = TimeOfDay.fromDateTime(appointment.time);
  String name = appointment.doctor;
  String note = appointment.note ?? '';

  showModalBottomSheet(
    context: ctx,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    backgroundColor: Colors.grey[100],
    builder: (BuildContext context) {
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
                    'Edit Appointment',
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
              Align(
                alignment: Alignment.centerRight,
                child: CupertinoButton(
                  child: const Icon(Icons.more_horiz, size: 25),
                  onPressed: () {
                    _showActionSheet(context, appointment);
                  },
                ),
              )
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                spacerHeight(16),
                SelectDateTime(
                  selectDateTime: selectedDate,
                  onDateChanged: (DateTime newDate) {
                    selectedDate = newDate;
                  },
                  onTimeChanged: (TimeOfDay newTime) {
                    selectedTime = newTime;
                  },
                ),
                spacerHeight(16),
                DoctorInputField(
                  doctor: appointment.doctor,
                  note: appointment.note,
                  onDoctorChanged: (p0) => name = p0,
                  onNoteChanged: (p0) => note = p0,
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
                        ? () {
                            context.read<AppointmentBloc>().add(
                                  AppointmentUpdate(appointment.copyWith(
                                    time: DateTime(
                                      selectedDate.year,
                                      selectedDate.month,
                                      selectedDate.day,
                                      selectedTime.hour,
                                      selectedTime.minute,
                                    ),
                                    doctor: name,
                                    note: note,
                                  )),
                                );
                            context
                                .read<AppointmentBloc>()
                                .add(const AppointmentsFetch(1));
                            Navigator.of(context).pop();
                          }
                        : null,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color?>(
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
      );
    },
  );
}

void _showActionSheet(BuildContext context, Appointment appointment) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            context.read<AppointmentBloc>().add(
                  AppointmentDelete(appointment),
                );
            context.read<AppointmentBloc>().add(const AppointmentsFetch(1));
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: const Text('Delete Appointment'),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}
