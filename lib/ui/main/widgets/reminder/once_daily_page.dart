part of '../widgets.dart';

class OnceDailyPage extends StatefulWidget {
  final ContainerModel container;
  final TimeOfDay initialTime;
  final int dose;
  final bool isCriticalAlertEnabled;
  final ValueChanged<TimeOfDay> onTimeChanged;
  final ValueChanged<bool> onCriticalAlertChanged;
  final Function(int) onDoseChanged;
  final Function() onSave;

  const OnceDailyPage({
    super.key,
    required this.container,
    required this.initialTime,
    required this.dose,
    required this.isCriticalAlertEnabled,
    required this.onTimeChanged,
    required this.onCriticalAlertChanged,
    required this.onDoseChanged,
    required this.onSave,
  });

  @override
  State<OnceDailyPage> createState() => _OnceDailyPageState();
}

class _OnceDailyPageState extends State<OnceDailyPage> {
  late TimeOfDay selectedTime;
  late int selectedDose;
  late bool isCriticalAlertEnabled;
  late TextEditingController doseController;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.initialTime;
    selectedDose = widget.dose;
    isCriticalAlertEnabled = widget.isCriticalAlertEnabled;
    doseController = TextEditingController(text: selectedDose.toString());
  }

  @override
  void dispose() {
    doseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildReminderSection(),
        _buildCriticalAlertSection(),
        const Spacer(),
        _buildSaveButton(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildReminderSection() {
    return CupertinoListSection.insetGrouped(
      header: const Text('When would you like to be reminded?'),
      children: [
        _buildTimeTile(),
        _buildDoseTile(),
      ],
    );
  }

  Widget _buildTimeTile() {
    return CupertinoListTile(
      onTap: _onTimeTileTapped,
      title: const Text('Time'),
      trailing: _buildTimeDisplay(),
    );
  }

  Widget _buildDoseTile() {
    return CupertinoListTile(
      onTap: _onDoseTileTapped,
      title: const Text('Dose'),
      trailing: Text('$selectedDose Pill(s)'),
    );
  }

  Widget _buildCriticalAlertSection() {
    return CupertinoListSection.insetGrouped(
      footer: Text(
        'Critical alerts ensure you receive reminders even in silent/do-not-disturb mode.',
        style: captionTextStyle.copyWith(
          color: CupertinoColors.systemGrey,
        ),
      ),
      children: [
        CupertinoListTile(
          title: const Text('Enable Critical Alerts'),
          trailing: CupertinoSwitch(
            value: isCriticalAlertEnabled,
            onChanged: _onCriticalAlertChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return CupertinoButton.filled(
      sizeStyle: CupertinoButtonSize.medium,
      onPressed: widget.onSave,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: const Text('Save'),
    );
  }

  Widget _buildTimeDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        DateFormat.jm().format(
          DateTime(0, 0, 0, selectedTime.hour, selectedTime.minute),
        ),
      ),
    );
  }

  Future<void> _onTimeTileTapped() async {
    final newTime = await _showTimePicker();
    if (newTime != null) {
      setState(() => selectedTime = newTime);
      widget.onTimeChanged(newTime);
    }
  }

  void _onDoseTileTapped() {
    showCupertinoDialog(
      context: context,
      builder: (context) => _buildDoseDialog(),
    );
  }

  Widget _buildDoseDialog() {
    return CupertinoAlertDialog(
      title: const Text('Dose'),
      content: Column(
        children: [
          Text('pill(s)', style: captionTextStyle),
          spacerHeight(8),
          CupertinoTextField(
            controller: doseController,
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
          onPressed: _onDoseDialogConfirmed,
          child: const Text('OK'),
        ),
      ],
    );
  }

  void _onDoseDialogConfirmed() {
    if (doseController.text.isNotEmpty) {
      setState(() {
        selectedDose = int.parse(doseController.text);
      });
      widget.onDoseChanged(selectedDose);
      Navigator.of(context).pop();
    } else {
      _showErrorDialog('Please enter a valid dose.');
    }
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

  void _onCriticalAlertChanged(bool value) {
    setState(() => isCriticalAlertEnabled = value);
    widget.onCriticalAlertChanged(value);
  }

  Future<TimeOfDay?> _showTimePicker() async {
    TimeOfDay tempPickedTime = selectedTime;

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
                    initialDateTime: DateTime(
                      0,
                      0,
                      0,
                      selectedTime.hour,
                      selectedTime.minute,
                    ),
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
