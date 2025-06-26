part of '../widgets.dart';

void showReminderDetail(BuildContext context, Reminder reminder) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    // useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.grey[100],
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.8,
        child: ReminderDetail(reminder: reminder),
      );
    },
    // builder: (context) {
    //   return ReminderDetail(reminder: reminder);
    // },
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
      children: [
        // iOS-style header
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [defaultShadow],
          ),
          child: Row(
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                child:
                    const Text('Close', style: TextStyle(color: Colors.blue)),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const Spacer(),
              Center(
                child: Text(
                  'Reminder Details',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const Spacer(),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child:
                    const Icon(Icons.more_horiz, size: 25, color: Colors.blue),
                onPressed: () => _showActionSheet(context, reminder),
              ),
            ],
          ),
        ),
        // Content with improved layout
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Medicine Section
              _buildSection(
                icon: OptimizedIcon(
                  assetPath: 'assets/icons/pill.png',
                  size: 24,
                  color: kPrimaryColor,
                ),
                title: 'Medicine',
                items: [
                  if (reminder.medicineName.isNotEmpty)
                    _buildDetailItem('Name', reminder.medicineName),
                  if (reminder.dosage.isNotEmpty)
                    _buildDetailItem('Dosage', reminder.dosage.join(', ')),
                  if (reminder.medicineLeft != null)
                    _buildDetailItem(
                        'Quantity Left', reminder.medicineLeft!.toString()),
                ],
              ),
              const SizedBox(height: 20),
              // Schedule Section
              _buildSection(
                icon: OptimizedIcon(
                  assetPath: 'assets/icons/calendar.png',
                  size: 24,
                  color: kPrimaryColor,
                ),
                title: 'Schedule',
                items: [
                  _buildDetailItem('Type', _getReminderTypeName(reminder.type)),
                  _buildDetailItem(
                    'Times',
                    reminder.times
                        .map((t) => DateFormat.Hm()
                            .format(DateTime(2023, 1, 1, t.hour, t.minute)))
                        .join(', '),
                  ),
                  if (reminder.daysofWeek != null &&
                      reminder.daysofWeek!.isNotEmpty)
                    _buildDetailItem(
                      'Days',
                      reminder.daysofWeek!
                          .map((d) => _getDayName(d))
                          .join(', '),
                    ),
                  if (reminder.endDate != null)
                    _buildDetailItem(
                      'End Date',
                      DateFormat.yMMMd().format(reminder.endDate!),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              // Status Section
              _buildSection(
                icon: const Icon(Icons.info_outline,
                    size: 24, color: kPrimaryColor),
                title: 'Status',
                items: [
                  _buildDetailItem(
                    'Status',
                    reminder.isActive ? 'Active' : 'Inactive',
                    valueColor: reminder.isActive ? Colors.green : Colors.grey,
                  ),
                  if (reminder.assignedTo != null)
                    _buildDetailItem(
                        'Assigned To', reminder.assignedTo!.userName ?? 'N/A'),
                  if (reminder.note != null && reminder.note!.isNotEmpty)
                    _buildDetailItem('Notes', reminder.note!),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required Widget icon,
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: valueColor ?? Colors.black87,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  String _getDayName(Days day) {
    switch (day) {
      case Days.monday:
        return 'Monday';
      case Days.tuesday:
        return 'Tuesday';
      case Days.wednesday:
        return 'Wednesday';
      case Days.thursday:
        return 'Thursday';
      case Days.friday:
        return 'Friday';
      case Days.saturday:
        return 'Saturday';
      case Days.sunday:
        return 'Sunday';
    }
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
        return 'Every ${reminder.times.first.hour} Hours';
      case ReminderType.intervaldays:
        return 'Every ${reminder.daysofWeek} Days';
      case ReminderType.specificDays:
        return 'Specific Days';
      case ReminderType.cyclic:
        return 'Cyclic';
    }
  }

  void _showActionSheet(BuildContext context, Reminder reminder) {
    final bottomSheetContext = context;
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              // Add edit functionality here
            },
            child: const Text('Edit Reminder'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(bottomSheetContext);
              context.read<ReminderBloc>().add(DeleteReminder(reminder));
            },
            child: const Text('Delete Reminder'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }
}
