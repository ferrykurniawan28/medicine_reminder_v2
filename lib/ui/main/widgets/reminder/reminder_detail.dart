part of '../widgets.dart';

void showReminderDetail(BuildContext context, Reminder reminder) {
  showModalBottomSheet(
    context: context,
    // isScrollControlled: false,
    scrollControlDisabledMaxHeightRatio: 0.92,
    // useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.grey[100],
    builder: (context) {
      return ReminderDetail(reminder: reminder);
    },
    // builder: (context) {
    //   return ReminderDetail(reminder: reminder);
    // },
  );
}

class ReminderDetail extends StatefulWidget {
  const ReminderDetail({
    super.key,
    required this.reminder,
  });

  final Reminder reminder;

  @override
  State<ReminderDetail> createState() => _ReminderDetailState();
}

class _ReminderDetailState extends State<ReminderDetail> {
  final NetworkService _networkService = NetworkService();
  String _hasTaken = '';
  String _time = '';
  int _logId = 0;
  int _dosage = 0;

  @override
  void initState() {
    super.initState();
    _fetchMedicineLog();
  }

  void _fetchMedicineLog() async {
    try {
      final response = await _networkService.get(
        '$baseUrl/users/${widget.reminder.assignedTo?.userId}/medications/reminder/${widget.reminder.id}',
      );

      // print('Medicine log response: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          _hasTaken = data['status'] ?? '';
          _logId = data['log_id'] ?? 0;
          _time = data['scheduled_time'] ?? '';
          _dosage = data['dosage'] ?? 0;
        });
      } else {
        // Handle non-200 responses
      }
    } catch (e) {
      print('Error fetching medicine log: $e');
    }
  }

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
                onPressed: () => _showActionSheet(context, widget.reminder),
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
                  if (widget.reminder.medicineName.isNotEmpty)
                    _buildDetailItem('Name', widget.reminder.medicineName),
                  if (widget.reminder.dosage.isNotEmpty)
                    _buildDetailItem(
                        'Dosage', widget.reminder.dosage.join(', ')),
                  if (widget.reminder.medicineLeft != null)
                    _buildDetailItem('Quantity Left',
                        widget.reminder.medicineLeft!.toString()),
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
                  _buildDetailItem(
                      'Type', _getReminderTypeName(widget.reminder.type)),
                  _buildDetailItem(
                    'Times',
                    widget.reminder.times
                        .map((t) => DateFormat.Hm()
                            .format(DateTime(2023, 1, 1, t.hour, t.minute)))
                        .join(', '),
                  ),
                  if (widget.reminder.daysofWeek != null &&
                      widget.reminder.daysofWeek!.isNotEmpty)
                    _buildDetailItem(
                      'Days',
                      widget.reminder.daysofWeek!
                          .map((d) => _getDayName(d))
                          .join(', '),
                    ),
                  if (widget.reminder.endDate != null)
                    _buildDetailItem(
                      'End Date',
                      DateFormat.yMMMd().format(widget.reminder.endDate!),
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
                  // _buildDetailItem(
                  //   'Status',
                  //   widget.reminder.isActive ? 'Active' : 'Inactive',
                  //   valueColor:
                  //       widget.reminder.isActive ? Colors.green : Colors.grey,
                  // ),
                  _buildDetailItem('Status', _hasTaken),
                  if (widget.reminder.assignedTo != null)
                    _buildDetailItem('Assigned To',
                        widget.reminder.assignedTo!.userName ?? 'N/A'),
                  if (widget.reminder.createdBy != null)
                    _buildDetailItem('Created By',
                        widget.reminder.createdBy!.userName ?? 'N/A'),
                  if (widget.reminder.note != null &&
                      widget.reminder.note!.isNotEmpty)
                    _buildDetailItem('Notes', widget.reminder.note!),
                ],
              ),
              spacerHeight(20),
              if (_hasTaken != 'taken')
                ElevatedButton.icon(
                  onPressed: () async {
                    // final NetworkService _networkService = NetworkService();

                    // final response = await _networkService.get(
                    //   '$baseUrl/users/${reminder.assignedTo?.userId}/medications/reminders/${reminder.id}',
                    // );
                    Navigator.pop(context);
                    Modular.to.pushNamed('/take-medicine', arguments: {
                      'medicine_name': widget.reminder.medicineName,
                      'dosage': _dosage,
                      'reminder_time': _time,
                      'reminder_id': widget.reminder.id!,
                      'log_id': _logId,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.check, size: 20),
                  label: const Text(
                    'Take Medicine',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
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
        return 'Every ${widget.reminder.times.first.hour} Hours';
      case ReminderType.intervaldays:
        return 'Every ${widget.reminder.daysofWeek} Days';
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
          // CupertinoActionSheetAction(
          //   onPressed: () {
          //     showReminderEdit(context, reminder);
          //   },
          //   child: const Text('Edit Reminder'),
          // ),
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
