part of '../widgets.dart';

class OnceTwiceDailyPage extends StatefulWidget {
  final ContainerModel container;
  final bool isOnce;

  const OnceTwiceDailyPage({
    super.key,
    required this.container,
    required this.isOnce,
  });

  @override
  State<OnceTwiceDailyPage> createState() => _OnceTwiceDailyPageState();
}

class _OnceTwiceDailyPageState extends State<OnceTwiceDailyPage> {
  late TimeOfDay selectedTime;
  TimeOfDay? secondTime;
  late TextEditingController doseController;
  TextEditingController? secondDoseController;
  bool isCriticalAlertEnabled = false;

  @override
  void initState() {
    super.initState();
    selectedTime = const TimeOfDay(hour: 8, minute: 0);
    secondTime = widget.isOnce ? null : const TimeOfDay(hour: 20, minute: 0);
    doseController = TextEditingController(text: '1');
    secondDoseController =
        widget.isOnce ? null : TextEditingController(text: '1');
  }

  @override
  void dispose() {
    doseController.dispose();
    secondDoseController?.dispose();
    super.dispose();
  }

  void _save() {
    final dose = int.tryParse(doseController.text);
    final secondDose =
        widget.isOnce ? null : int.tryParse(secondDoseController?.text ?? '');

    if (dose == null || dose <= 0 || (secondDose != null && secondDose <= 0)) {
      _showErrorDialog('Please enter a valid dose.');
      return;
    }

    final reminder = Reminder(
      containerId: widget.container.id,
      times: [selectedTime, if (secondTime != null) secondTime!],
      dosage: [dose, if (secondDose != null) secondDose],
      isAlert: isCriticalAlertEnabled,
      type: widget.isOnce ? ReminderType.onceDaily : ReminderType.twiceDaily,
      medicineName: widget.container.medicineName!,
      deviceId: widget.container.deviceId,
      medicineLeft: widget.container.quantity,
    );

    context.read<ReminderBloc>().add(
          AddReminder(reminder),
        );
    Modular.to.popUntil(
      (route) => route.settings.name == '/home',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
      body: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(widget.container.medicineName ?? 'Empty'),
        ),
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          child: Stack(
            children: [
              CupertinoListSection(
                header: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.container.medicineName!,
                        style: captionTextStyle),
                    Text(
                      'When would you like to be reminded?',
                      style: bodyTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: medium,
                      ),
                    ),
                  ],
                ),
                children: [
                  _buildReminderSection(
                    selectedTime,
                    doseController,
                    Text(
                      widget.isOnce ? 'Intake' : 'First Intake',
                      style: captionTextStyle,
                    ),
                  ),
                  if (!widget.isOnce && secondTime != null)
                    _buildReminderSection(
                      secondTime!,
                      secondDoseController!,
                      Text(
                        'Second Intake',
                        style: captionTextStyle,
                      ),
                    ),
                  _buildCriticalAlertSection(),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildSaveButton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReminderSection(
      TimeOfDay time, TextEditingController controller, Text header) {
    return CupertinoListSection.insetGrouped(
      header: header,
      children: [
        _buildTimeTile(time),
        _buildDoseTile(controller),
      ],
    );
  }

  Widget _buildTimeTile(TimeOfDay time) {
    return CupertinoListTile(
      onTap: () => _onTimeTileTapped(time),
      title: const Text('Time'),
      trailing: _buildTimeDisplay(time),
    );
  }

  Widget _buildDoseTile(TextEditingController controller) {
    return CupertinoListTile(
      onTap: () => _onDoseTileTapped(controller),
      title: const Text('Dose'),
      trailing: Text('${controller.text} Pill(s)'),
    );
  }

  Widget _buildCriticalAlertSection() {
    return CupertinoListSection.insetGrouped(
      footer: Text(
        'Critical alerts ensure you receive reminders even in silent/do-not-disturb mode.',
        style: captionTextStyle.copyWith(color: CupertinoColors.systemGrey),
      ),
      children: [
        CupertinoListTile(
          title: const Text('Enable Critical Alerts'),
          trailing: CupertinoSwitch(
            value: isCriticalAlertEnabled,
            onChanged: (value) =>
                setState(() => isCriticalAlertEnabled = value),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return CupertinoButton.filled(
      sizeStyle: CupertinoButtonSize.medium,
      onPressed: _save,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: const Text('Save'),
    );
  }

  Widget _buildTimeDisplay(TimeOfDay time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        DateFormat.jm().format(DateTime(0, 0, 0, time.hour, time.minute)),
      ),
    );
  }

  Future<void> _onTimeTileTapped(TimeOfDay time) async {
    final newTime = await _showTimePicker(time);
    if (newTime != null) {
      setState(() {
        if (time == selectedTime) {
          selectedTime = newTime;
        } else if (time == secondTime) {
          secondTime = newTime;
        }
      });
    }
  }

  void _onDoseTileTapped(TextEditingController controller) {
    showCupertinoDialog(
      context: context,
      builder: (context) => _buildDoseDialog(controller),
    );
  }

  Widget _buildDoseDialog(TextEditingController controller) {
    return CupertinoAlertDialog(
      title: const Text('Dose'),
      content: Column(
        children: [
          Text('pill(s)', style: captionTextStyle),
          spacerHeight(8),
          CupertinoTextField(
            controller: controller,
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
            if (controller.text.isNotEmpty) {
              setState(() {});
              Navigator.of(context).pop();
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
}
