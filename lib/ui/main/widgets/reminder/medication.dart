part of '../widgets.dart';

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
  final List<Widget> _pages = [];
  int? containerIndex;
  int? optionIndex;

  @override
  void initState() {
    super.initState();
    _pages.add(_buildContainerListPage());
  }

  void _pushPage(Widget page) {
    setState(() => _pages.add(page));
  }

  void _popPage() {
    if (_pages.length > 1) {
      setState(() => _pages.removeLast());
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          _buildHeader(),
          Expanded(child: _pages.last),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _popPage,
            child: Icon(
              _pages.length > 1
                  ? CupertinoIcons.back
                  : CupertinoIcons.xmark_circle_fill,
              size: 24,
            ),
          ),
          const Spacer(),
          Text('Add Reminder', style: Theme.of(context).textTheme.titleMedium),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildContainerListPage() {
    final device = context.read<DeviceBloc>().device;
    if (device == null) return const Center(child: Text('No device found'));

    return CupertinoListSection.insetGrouped(
      header: Text('Containers', style: bodyTextStyle),
      children: List.generate(device.containers.length, (index) {
        final container = device.containers[index];
        return CupertinoListTile(
          title: Text('Container ${container.containerId}'),
          subtitle: Text(container.medicineName ?? 'Empty'),
          trailing: containerIndex == index
              ? const Icon(CupertinoIcons.check_mark)
              : null,
          onTap: () {
            if (container.medicineName == null) {
              _showEmptyContainerDialog();
              return;
            }
            setState(() => containerIndex = index);
            _pushPage(_buildRoutineSelectionPage(container));
          },
        );
      }),
    );
  }

  Widget _buildRoutineSelectionPage(ContainerModel container) {
    return CupertinoListSection.insetGrouped(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            container.medicineName ?? 'Empty',
            style: captionTextStyle.copyWith(),
          ),
          Text(
            'How often do you take this medication?',
            style: bodyTextStyle,
          ),
        ],
      ),
      children: [
        CupertinoListTile(
          title: const Text('Once Daily'),
          onTap: () {
            _pushPage(OnceTwiceDailyPage(
              container: container,
              isOnce: true,
            ));
          },
        ),
        CupertinoListTile(
          title: const Text('Twice Daily'),
          onTap: () {
            _pushPage(OnceTwiceDailyPage(
              container: container,
              isOnce: false,
            ));
          },
        ),
        CupertinoListTile(
          title: const Text('More options...'),
          onTap: () => _pushPage(MoreOptionsPage(
            container: container,
          )),
        ),
      ],
    );
  }

  void _showEmptyContainerDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Container is empty'),
        content:
            const Text('Please fill the container before setting a reminder.'),
        actions: [
          CupertinoDialogAction(
            onPressed: Navigator.of(context).pop,
            child: const Text('OK'),
          )
        ],
      ),
    );
  }
}
