part of '../widgets.dart';

class MultipleTimesDaily extends StatefulWidget {
  final ContainerModel container;
  final int howManyTimes;
  const MultipleTimesDaily({
    super.key,
    required this.container,
    required this.howManyTimes,
  });

  @override
  State<MultipleTimesDaily> createState() => _MultipleTimesDailyState();
}

class _MultipleTimesDailyState extends State<MultipleTimesDaily> {
  bool isCriticalAlert = false;
  late List<TimeOfDay> selectedTimes = [];
  late List<int> dosage = [];
  TextEditingController _doseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize selectedTimes with howManyTimes entries starting at 08:00
    selectedTimes = List.generate(
      widget.howManyTimes,
      (index) => TimeOfDay(hour: 8 + index, minute: 0),
    );
    dosage = List.generate(widget.howManyTimes, (index) => 1);
  }

  // TODO: adjust for prod
  void _save() {
    if (dosage.isEmpty) {
      _showErrorDialog('Please enter a valid dose.');
      return;
    }
    if (selectedTimes.isEmpty) {
      _showErrorDialog('Please select a time.');
      return;
    }

    Reminder newReminder = Reminder(
      type: ReminderType.multipleTimesDaily,
      times: selectedTimes,
      medicineName: widget.container.medicineName!,
      medicineLeft: widget.container.quantity,
      dosage: dosage,
      isAlert: isCriticalAlert,
    );

    context.read<ReminderBloc>().add(
          AddReminder(
            newReminder,
          ),
        );
    Modular.to.popUntil((route) => route.settings.name == '/home');
  }

  Future<TimeOfDay?> _showTimePicker(TimeOfDay initialTime) async {
    TimeOfDay tempPickedTime = initialTime;

    return await showCupertinoModalPopup<TimeOfDay>(
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.only(top: 6),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    CupertinoButton(
                      child: const Text('Done'),
                      onPressed: () =>
                          Navigator.of(context).pop(tempPickedTime),
                    ),
                  ],
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime:
                        DateTime(0, 0, 0, initialTime.hour, initialTime.minute),
                    onDateTimeChanged: (dateTime) {
                      tempPickedTime = TimeOfDay(
                        hour: dateTime.hour,
                        minute: dateTime.minute,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _doseController.dispose();
    selectedTimes.clear();
    dosage.clear();
    super.dispose();
  }

  Widget _buildDoseDialog(int dosage) {
    _doseController = TextEditingController(text: dosage.toString());
    return CupertinoAlertDialog(
      title: const Text('Dose'),
      content: Column(
        children: [
          Text('pill(s)', style: captionTextStyle),
          spacerHeight(8),
          CupertinoTextField(
            controller: _doseController,
            keyboardType: TextInputType.number,
            autofocus: true,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        CupertinoDialogAction(
          onPressed: () {
            if (_doseController.text.isNotEmpty) {
              Navigator.of(context).pop(int.parse(_doseController.text));
            } else {
              _showErrorDialog('Please enter a valid dose.');
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Multiple Times Daily'),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              CupertinoListSection.insetGrouped(
                header: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.container.medicineName ?? 'Empty',
                      style: captionTextStyle.copyWith(),
                    ),
                    Text(
                      'How many times do you take this medication?',
                      style: bodyTextStyle,
                    ),
                  ],
                ),
                children: [
                  for (int i = 0; i < widget.howManyTimes; i++)
                    CupertinoListTile(
                      title: GestureDetector(
                        onTap: () => _showTimePicker(selectedTimes[i]),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(DateFormat.jm().format(
                            DateTime(0, 0, 0, selectedTimes[i].hour,
                                selectedTimes[i].minute),
                          )),
                        ),
                      ),
                      trailing: CupertinoButton(
                        onPressed: () async {
                          final newDosage = await showCupertinoDialog<int>(
                            context: context,
                            builder: (context) => _buildDoseDialog(dosage[i]),
                          );
                          if (newDosage != null) {
                            setState(() {
                              dosage[i] = newDosage;
                            });
                          }
                        },
                        child: Text(
                          '${dosage[i]} Pill(s)',
                          style: captionTextStyle.copyWith(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  CupertinoListTile(
                    title: Text(
                      'Enable Critical alerts',
                      style: bodyTextStyle,
                    ),
                    trailing: CupertinoSwitch(
                      value: isCriticalAlert,
                      onChanged: (value) {
                        setState(() {
                          isCriticalAlert = value;
                        });
                      },
                    ),
                  )
                ],
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
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
