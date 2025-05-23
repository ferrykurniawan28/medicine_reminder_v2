part of '../widgets.dart';

void showReminderDetail(BuildContext context, Reminder reminder) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.grey[100],
    builder: (context) {
      return ReminderDetail(reminder: reminder);
    },
  );
}

class ReminderDetail extends StatelessWidget {
  const ReminderDetail({
    super.key,
    required this.reminder,
  });

  final Reminder reminder;

  @override
  Widget build(BuildContext context) {
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
                boxShadow: [defaultShadow],
              ),
              child: Center(
                child: Text(
                  'Reminder Details',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: CupertinoButton(
                child: const Text('Close'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: CupertinoButton(
                child: const Icon(Icons.more_horiz, size: 25),
                onPressed: () => _showActionSheet(context, reminder),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildDetailItem(
                icon: Image.asset(
                  'assets/icons/pill.png',
                  width: 24,
                  height: 24,
                ),
                title: 'Medicine Name',
                // value: reminder.medicineName,
              ),
              spacerHeight(16),
              _buildDetailItem(
                title: 'Dosage',
                value: reminder.dosage.join(', '),
              ),
              spacerHeight(16),
              _buildDetailItem(
                icon: Image.asset(
                  'assets/icons/calendar.png',
                  width: 24,
                  height: 24,
                ),
                title: 'Medication Schedule',
                value: _getReminderTypeName(reminder.type),
              ),
              spacerHeight(16),
              _buildDetailItem(
                title: 'Status',
                value: reminder.isActive ? 'Active' : 'Inactive',
              ),
              spacerHeight(16),
              _buildDetailItem(
                title: 'Medicine Left',
                value: reminder.medicineLeft != null
                    ? reminder.medicineLeft.toString()
                    : 'Not specified',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    String? title,
    String? value,
    Widget? icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [defaultShadow],
      ),
      child: Row(
        children: [
          icon ?? const SizedBox.shrink(),
          if (icon != null) spacerWidth(8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) Text(title, style: subtitleTextStyle),
              spacerHeight(4),
              if (value != null) Text(value, style: bodyTextStyle),
            ],
          ),
        ],
      ),
    );
  }

  String _getReminderTypeName(ReminderType type) {
    switch (type) {
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

  void _showActionSheet(BuildContext context, Reminder reminder) {
    // Store the bottom sheet context before showing the action sheet
    final bottomSheetContext = context;

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext actionSheetContext) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(actionSheetContext);
              Navigator.pop(bottomSheetContext);
              context.read<ReminderBloc>().add(DeleteReminder(reminder.id!));
            },
            child: const Text('Delete Reminder'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(actionSheetContext),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
