part of '../widgets.dart';

class AddReminderScreen extends StatelessWidget {
  const AddReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final device = context.read<DeviceBloc>().device;
    if (device == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('No device connected'),
        ),
      );
    }

    return CupertinoPageScaffold(
      backgroundColor: kPrimaryColor,
      navigationBar: defaultCupertinoAppBar('Add Reminder', context: context),
      child: SafeArea(
        child: CupertinoListSection.insetGrouped(
          header: Text('Containers', style: bodyTextStyle),
          children: List.generate(device.containers.length, (index) {
            final container = device.containers[index];
            return CupertinoListTile(
              title: Text('Container ${container.containerId}'),
              subtitle: Text(container.medicineName ?? 'Empty'),
              onTap: () {
                if (container.medicineName == null) {
                  _showEmptyContainerDialog(context);
                  return;
                }
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) =>
                        RoutineSelectionScreen(container: container),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }

  void _showEmptyContainerDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Container is empty'),
        content:
            const Text('Please fill the container before setting a reminder.'),
        actions: [
          CupertinoDialogAction(
            onPressed: Modular.to.pop,
            child: const Text('OK'),
          )
        ],
      ),
    );
  }
}
