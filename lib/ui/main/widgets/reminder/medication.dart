part of '../widgets.dart';

class AddReminderScreen extends StatelessWidget {
  final User assignedUser;
  final bool isParental;
  const AddReminderScreen(
      {super.key, required this.assignedUser, this.isParental = false});

  Future<Device> _fetchParentalDevice() async {
    final networkService = NetworkService();
    final response = await networkService.get<DeviceModel>(
      '$deviceUserUrl/${assignedUser.userId!}',
      fromData: (data) {
        if (data is List && data.isNotEmpty) {
          return DeviceModel.fromJson(data.first as Map<String, dynamic>);
        } else if (data is Map<String, dynamic>) {
          return DeviceModel.fromJson(data);
        } else {
          throw Exception('Invalid device data format');
        }
      },
    );

    if (response.statusCode == 200 && response.data != null) {
      return response.data!;
    } else {
      throw Exception('Failed to fetch device: ${response.message}');
    }
  }

  Future<Device> _fetchUserDevice(BuildContext context) async {
    final networkService = NetworkService();
    final response = await networkService.get<DeviceModel>(
      '$deviceUserUrl/${assignedUser.userId!}',
      fromData: (data) {
        if (data is List && data.isNotEmpty) {
          return DeviceModel.fromJson(data.first as Map<String, dynamic>);
        } else if (data is Map<String, dynamic>) {
          return DeviceModel.fromJson(data);
        } else {
          throw Exception('Invalid device data format');
        }
      },
    );

    if (response.statusCode == 200 && response.data != null) {
      return response.data!;
    } else {
      Device? device = context.read<DeviceBloc>().device;
      if (device != null) {
        return device;
      } else {
        throw Exception('Failed to fetch device: ${response.message}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // If it's parental mode, use FutureBuilder to fetch device from server
    if (isParental) {
      return FutureBuilder<Device>(
        future: _fetchParentalDevice(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(title: const Text('Add Reminder')),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Add Reminder')),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: ${snapshot.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (snapshot.hasData) {
            return _buildReminderScreen(context, snapshot.data!);
          }

          return Scaffold(
            appBar: AppBar(title: const Text('Add Reminder')),
            body: const Center(
              child: Text('No device data available'),
            ),
          );
        },
      );
    } else {
      return FutureBuilder<Device>(
        future: _fetchUserDevice(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(title: const Text('Add Reminder')),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Add Reminder')),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: ${snapshot.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (snapshot.hasData) {
            return _buildReminderScreen(context, snapshot.data!);
          }

          return Scaffold(
            appBar: AppBar(title: const Text('Add Reminder')),
            body: const Center(
              child: Text('No device data available'),
            ),
          );
        },
      );
    }
    // Device? device = context.read<DeviceBloc>().device;

    // if (device == null) {
    //   return Scaffold(
    //     appBar: AppBar(),
    //     body: const Center(
    //       child: Text('No device connected'),
    //     ),
    //   );
    // }
  }

  Widget _buildReminderScreen(BuildContext context, Device device) {
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
                    builder: (context) => RoutineSelectionScreen(
                        container: container,
                        assignedUser: assignedUser,
                        isParental: isParental),
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
