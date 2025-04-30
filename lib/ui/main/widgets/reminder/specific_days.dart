part of '../widgets.dart';

class SpecificDays extends StatefulWidget {
  final ContainerModel container;
  final List<Days> days;
  const SpecificDays({
    super.key,
    required this.container,
    required this.days,
  });

  @override
  State<SpecificDays> createState() => _SpecificDaysState();
}

class _SpecificDaysState extends State<SpecificDays> {
  bool isCriticalAlert = false;
  TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 0);
  int dosage = 1;

  // Todo: adjust for prod
  void _save() {
    if (dosage <= 0) {
      _showErrorDialog('Please enter a valid dose.');
      return;
    }

    Reminder newReminder = Reminder(
      type: ReminderType.specificDays,
      times: [selectedTime],
      medicineName: widget.container.medicineName!,
      medicineLeft: widget.container.quantity,
      dosage: [dosage],
      isAlert: isCriticalAlert,
    );

    context.read<ReminderBloc>().add(
          AddReminder(
            newReminder,
          ),
        );
    Modular.to.popUntil((route) => route.settings.name == '/home');
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CupertinoPageScaffold(
            backgroundColor: Colors.white,
            navigationBar: const CupertinoNavigationBar(
              middle: Text(
                'Specific Days',
              ),
            ),
            child: SafeArea(
              child: CupertinoListSection.insetGrouped(
                header: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.container.medicineName ?? 'Empty',
                      style: captionTextStyle.copyWith(),
                    ),
                    Text(
                      'when would you like to be reminded?',
                      style: bodyTextStyle,
                    ),
                    spacerHeight(10),
                    Text(
                      widget.days.isNotEmpty
                          ? 'Intake on ${widget.days.map((day) => ReminderDayHelper.getName(day)).join(', ')}'
                          : 'No days selected',
                      style: captionTextStyle.copyWith(
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                children: [
                  CupertinoListTile(
                    title: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(DateFormat.jm().format(
                        DateTime(
                            0, 0, 0, selectedTime.hour, selectedTime.minute),
                      )),
                    ),
                    trailing: CupertinoButton(
                        child: Text(
                          '$dosage pill(s)',
                          style: captionTextStyle,
                        ),
                        onPressed: () {}),
                  ),
                  CupertinoListTile(
                    title: const Text('Critical Alert'),
                    trailing: CupertinoSwitch(
                      value: isCriticalAlert,
                      onChanged: (value) {
                        setState(() {
                          isCriticalAlert = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoButton.filled(
                sizeStyle: CupertinoButtonSize.medium,
                onPressed: _save,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const Text('Save'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
