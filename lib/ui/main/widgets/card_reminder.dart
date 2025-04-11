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
  @override
  Widget build(BuildContext context) {
    String reminderType;
    switch (widget.reminder.type) {
      case ReminderType.onceDaily:
        reminderType = 'Once Daily';
        break;
      case ReminderType.twiceDaily:
        reminderType = 'Twice Daily';
        break;
      case ReminderType.multipleTimesDaily:
        reminderType = 'Multiple Times Daily';
        break;
      case ReminderType.intervalhours:
        reminderType = 'Interval Hours';
        break;
      case ReminderType.intervaldays:
        reminderType = 'Interval Days';
        break;
      case ReminderType.specificDays:
        reminderType = 'Specific Days';
        break;
      case ReminderType.cyclic:
        reminderType = 'Cyclic';
        break;
    }

    return Container(
      // height: 100,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        // gradient: LinearGradient(
        //   colors: [
        //     softBlueColor,
        //     softBlueColor.lighten(0.1),
        //   ],
        // ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          defaultShadow,
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4, // 40% of the Row
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
                  'Dosage: ${widget.reminder.dosage}',
                  style: captionTextStyle,
                ),
                Text(
                  'Left: ${widget.reminder.medicineLeft}',
                  style: bodyTextStyle,
                )
              ],
            ),
          ),
          Expanded(
            flex: 4, // 40% of the Row
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
                        DateFormat.jm().format(
                          DateTime(
                            0,
                            0,
                            0,
                            widget.reminder.times[0].hour,
                            widget.reminder.times[0].minute,
                          ),
                        ),
                        style: subtitleTextStyle.copyWith(
                          color: Colors.black,
                        ),
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
              value: widget.reminder.isActive,
              onChanged: (bool value) {
                setState(() {
                  widget.reminder.isActive = value;
                });
                context.read<ReminderBloc>().add(
                      UpdateReminderStatus(
                        widget.reminder.id!,
                        value,
                      ),
                    );
              },
            ),
          ),
        ],
      ),
    );
  }
}
