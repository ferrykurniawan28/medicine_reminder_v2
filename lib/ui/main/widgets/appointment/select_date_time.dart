part of '../widgets.dart';

class SelectDateTime extends StatefulWidget {
  final Function(DateTime) onDateChanged;
  final Function(TimeOfDay) onTimeChanged;
  final DateTime selectDateTime;
  const SelectDateTime({
    super.key,
    required this.onDateChanged,
    required this.onTimeChanged,
    required this.selectDateTime,
  });

  @override
  State<SelectDateTime> createState() => _SelectDateTimeState();
}

class _SelectDateTimeState extends State<SelectDateTime> {
  late DateTime _selectedDateTime;
  late TimeOfDay _selectedTime;
  late DateTime _tempDateTime;
  late TimeOfDay _tempTime;

  @override
  void initState() {
    super.initState();
    _tempDateTime = widget.selectDateTime;
    _tempTime = TimeOfDay.fromDateTime(widget.selectDateTime);
    _selectedDateTime = _tempDateTime;
    _selectedTime = _tempTime;
  }

  void _showDatePicker() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 300,
        padding: const EdgeInsets.only(top: 6.0),
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoButton(
                    child: const Text('Done'),
                    onPressed: () {
                      setState(() {
                        _selectedDateTime = _tempDateTime;
                        widget.onDateChanged(_selectedDateTime);
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: _tempDateTime,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime newDate) {
                    _tempDateTime = newDate;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTimePicker() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 300,
        padding: const EdgeInsets.only(top: 6.0),
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoButton(
                    child: const Text('Done'),
                    onPressed: () {
                      setState(() {
                        _selectedTime = _tempTime;
                        widget.onTimeChanged(_selectedTime);
                      });
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: DateTime(
                    _selectedDateTime.year,
                    _selectedDateTime.month,
                    _selectedDateTime.day,
                    _tempTime.hour,
                    _tempTime.minute,
                  ),
                  mode: CupertinoDatePickerMode.time,
                  minuteInterval: 5,
                  use24hFormat: false,
                  onDateTimeChanged: (DateTime newTime) {
                    setState(() {
                      _tempTime = TimeOfDay.fromDateTime(newTime);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: _showDatePicker,
              dense: true,
              title: Text(
                'Date',
                style: bodyTextStyle.copyWith(
                  color: Colors.black,
                ),
              ),
              trailing: Text(
                DateFormat('EEE, dd MMM yyyy').format(_selectedDateTime),
                style: bodyTextStyle,
              ),
            ),
            const Divider(height: 1),
            ListTile(
              onTap: _showTimePicker,
              dense: true,
              title: Text(
                'Time',
                style: bodyTextStyle.copyWith(
                  color: Colors.black,
                ),
              ),
              trailing: Text(
                _selectedTime.format(context),
                style: bodyTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
