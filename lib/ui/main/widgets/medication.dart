part of 'widgets.dart';

void addReminder(BuildContext ctx) {
  showModalBottomSheet(
    context: ctx,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: CupertinoColors.systemGroupedBackground,
    builder: (context) {
      return const AddReminderContent();
    },
  );
}

class AddReminderContent extends StatefulWidget {
  const AddReminderContent({super.key});

  @override
  State<AddReminderContent> createState() => _AddReminderContentState();
}

class _AddReminderContentState extends State<AddReminderContent> {
  int pageIndex = 0;
  int? containerIndex;
  int dose = 1;
  TimeOfDay selectedTime = const TimeOfDay(hour: 08, minute: 00);
  ReminderType? reminderType;
  bool isCriticalAlertEnabled = false;

  @override
  Widget build(BuildContext context) {
    final device = context.read<DeviceBloc>().device;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Expanded(
            child: _buildPageContent(device),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [defaultShadow],
          ),
          child: Center(
            child: Text(
              'Add Reminder',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: CupertinoButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPageContent(DeviceModel? device) {
    if (device == null) return const Text('No device found');

    switch (pageIndex) {
      case 0:
        return _buildContainerList(device);
      case 1:
        return _buildMedicationRoutine(device);
      case 2:
        return _buildOnceDailySection(device);
      default:
        return const Text('Page not found');
    }
  }

  Widget _buildContainerList(DeviceModel device) {
    return CupertinoListSection.insetGrouped(
      header: Text(
        'Containers',
        style: subtitleTextStyle.copyWith(
            fontSize: 16, fontWeight: FontWeight.w600),
      ),
      children: List.generate(
        device.containers.length,
        (index) {
          final container = device.containers[index];
          return CupertinoListTile(
            onTap: () => _onContainerTap(container, index),
            title: Text(
              'Container ${container.containerId}',
              style: bodyTextStyle,
            ),
            subtitle: Text(
              container.medicineName ?? 'Empty',
              style: captionTextStyle,
            ),
            trailing: (containerIndex == index)
                ? const Icon(CupertinoIcons.check_mark)
                : null,
          );
        },
      ),
    );
  }

  void _onContainerTap(ContainerModel container, int index) {
    if (container.medicineName == null) {
      _showEmptyContainerDialog();
      return;
    }
    setState(() {
      pageIndex = 1;
      containerIndex = index;
    });
  }

  void _showEmptyContainerDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Container is empty'),
          content: const Text(
              'Please fill the container before setting a reminder.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildMedicationRoutine(DeviceModel device) {
    return CupertinoListSection.insetGrouped(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            device.containers[containerIndex!].medicineName ?? 'Empty',
            style: captionTextStyle,
          ),
          Text(
            'How often do you take this medication?',
            style: subtitleTextStyle.copyWith(
                fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      children: [
        CupertinoListTile(
          onTap: () => setState(() => pageIndex = 2),
          title: Text('Once daily', style: bodyTextStyle),
        ),
        CupertinoListTile(
          title: Text('Twice daily', style: bodyTextStyle),
        ),
        CupertinoListTile(
          title: Text('On demand (no reminder needed)', style: bodyTextStyle),
        ),
        CupertinoListTile(
          title: Text('I need more options...', style: bodyTextStyle),
        ),
      ],
    );
  }

  Widget _buildOnceDailySection(DeviceModel device) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CupertinoListSection.insetGrouped(
          header: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                device.containers[containerIndex!].medicineName ?? 'Empty',
                style: captionTextStyle,
              ),
              Text(
                'When would you like to be reminded?',
                style: subtitleTextStyle.copyWith(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          children: [
            CupertinoListTile(
              title: Text('Time', style: bodyTextStyle),
              trailing: _buildTimeDisplay(),
            ),
            CupertinoListTile(
              title: Text('Dose', style: bodyTextStyle),
              trailing: Text('$dose Pill(s)', style: bodyTextStyle),
            ),
          ],
        ),
        _buildProminentRemindersSection(),
      ],
    );
  }

  Widget _buildTimeDisplay() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Text(
        DateFormat.jm().format(
          DateTime(0, 0, 0, selectedTime.hour, selectedTime.minute),
        ),
        style: bodyTextStyle,
      ),
    );
  }

  Widget _buildProminentRemindersSection() {
    return CupertinoListSection.insetGrouped(
      footer: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(CupertinoIcons.info, color: Colors.grey[400]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Critical alerts ensure that you receive reminders even when your phone is on silent or do not disturb mode.',
              style: bodyTextStyle.copyWith(fontSize: 12, fontWeight: light),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
      children: [
        CupertinoListTile(
          title: Text(
            'Prominent Reminders',
            style: bodyTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
          ),
        ),
        CupertinoListTile(
          // onTap: () {
          //   setState(() {
          //     isCriticalAlertEnabled = !isCriticalAlertEnabled;
          //   });
          // },
          title: Text('Enable Critical Alerts', style: bodyTextStyle),
          trailing: CupertinoSwitch(
            value: isCriticalAlertEnabled,
            onChanged: (value) {
              // TODO: ask notification permision
              setState(() {
                isCriticalAlertEnabled = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              if (pageIndex > 0)
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    shape: WidgetStateProperty.all(const CircleBorder()),
                  ),
                  onPressed: () => setState(() => pageIndex--),
                ),
              if (pageIndex > 0) spacerWidth(8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    shape: WidgetStateProperty.all(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ),
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
        LinearProgressIndicator(
          value: (pageIndex + 1) / 4,
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation<Color>(
            Color.fromARGB(255, 0, 122, 255),
          ),
        ),
      ],
    );
  }
}
