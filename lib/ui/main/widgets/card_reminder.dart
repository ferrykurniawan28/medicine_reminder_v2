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
  // Local state to handle immediate UI feedback
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _isActive = widget.reminder.isActive;
  }

  @override
  void didUpdateWidget(CardReminder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reminder.isActive != oldWidget.reminder.isActive) {
      setState(() {
        _isActive = widget.reminder.isActive;
      });
    }
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
              child: Switch(
                value: _isActive,
                activeTrackColor: kPrimaryColor,
                onChanged: (bool value) async {
                  // Immediate UI feedback
                  setState(() {
                    _isActive = value;
                  });

                  // Send update to BLoC
                  context.read<ReminderBloc>().add(
                        UpdateReminderStatus(
                          widget.reminder.copyWith(isActive: value),
                        ),
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
