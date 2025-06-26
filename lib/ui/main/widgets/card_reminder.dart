part of 'widgets.dart';

class CardReminder extends StatefulWidget {
  final Reminder reminder;
  const CardReminder({
    super.key,
    required this.reminder,
  });

  @override
  State<CardReminder> createState() => _CardReminderState();
}

class _CardReminderState extends State<CardReminder> {
  // Use ValueNotifier for state management
  late final ValueNotifier<bool> _isActiveNotifier;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _isActiveNotifier = ValueNotifier(widget.reminder.isActive);
  }

  @override
  void didUpdateWidget(CardReminder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reminder.isActive != oldWidget.reminder.isActive) {
      _isActiveNotifier.value = widget.reminder.isActive;
    }
  }

  @override
  void dispose() {
    _isActiveNotifier.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSwitchChanged(bool value) {
    _isActiveNotifier.value = value;

    // Debounce the update to the BLoC
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      context.read<ReminderBloc>().add(
            UpdateReminderStatus(
              widget.reminder.copyWith(isActive: value),
            ),
          );
    });
  }

  String get reminderType {
    switch (widget.reminder.type) {
      case ReminderType.onceDaily:
        return 'Once Daily';
      case ReminderType.twiceDaily:
        return 'Twice Daily';
      case ReminderType.multipleTimesDaily:
        return 'Multiple Times Daily';
      case ReminderType.intervalhours:
        return 'Interval Hours';
      case ReminderType.intervaldays:
        return 'Interval Days';
      case ReminderType.specificDays:
        return 'Specific Days';
      case ReminderType.cyclic:
        return 'Cyclic';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showReminderDetail(context, widget.reminder),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [defaultShadow],
          border: Border.all(color: kPrimaryColor, width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.reminder.medicineName,
                    style: subtitleTextStyle,
                  ),
                  Text(
                    'Dosage: ${widget.reminder.dosage.join(', ')}',
                    style: captionTextStyle.copyWith(
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                  Text(
                    'Left: ${widget.reminder.medicineLeft ?? 'Empty'}',
                    style: bodyTextStyle,
                  )
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    child: VerticalDivider(
                      width: 20,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                      color: darkGrayColor,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.reminder.times
                              .map((time) => DateFormat.jm().format(
                                    DateTime(
                                      0,
                                      0,
                                      0,
                                      time.hour,
                                      time.minute,
                                    ),
                                  ))
                              .join(', '),
                          style: subtitleTextStyle.copyWith(
                            color: Colors.black,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                        Text(
                          reminderType,
                          style: captionTextStyle.copyWith(
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: ValueListenableBuilder<bool>(
                valueListenable: _isActiveNotifier,
                builder: (context, isActive, child) {
                  return Switch(
                    value: isActive,
                    activeTrackColor: kPrimaryColor,
                    onChanged: _onSwitchChanged,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
