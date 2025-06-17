part of '../main.dart';

class DeviceView extends StatefulWidget {
  const DeviceView({super.key});

  @override
  State<DeviceView> createState() => _DeviceState();
}

// TODO: work on device
class _DeviceState extends State<DeviceView> {
  bool _isFetching = false; // Flag to prevent duplicate fetches
  int? userId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDevice();
    });
  }

  Future<void> _fetchDevice() async {
    if (_isFetching) {
      print('Fetch already in progress, skipping duplicate call.');
      return;
    }

    _isFetching = true; // Set fetching flag to true

    try {
      userId = await SharedPreference.getInt('userId');
      print('Fetching device for userId: $userId');

      if (userId == null) {
        print('User ID is null, cannot fetch device');
        return;
      }

      if (!mounted) return;

      context.read<DeviceBloc>().add(DeviceFetch(userId!));
    } catch (e) {
      print('Error fetching device: $e');
    } finally {
      _isFetching = false; // Reset fetching flag
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: defaultAppBar('Device', actions: [
      //   IconButton(onPressed: () {}, icon: const Icon(Icons.playlist_remove))
      // ]),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          // context.read<DeviceBloc>().add(DeviceRefresh());
        },
        child: ListView(children: [
          // const YourDevice(),
          BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
            if (state is DeviceLoaded) {
              return YourDevice(device: state.device);
            } else if (state is DeviceLoading) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  children: List.generate(2, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                    );
                  }),
                ),
              );
            }
            return const SizedBox();
          }),

          spacerHeight(20),
          BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
            if (state is DeviceLoaded) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.device.containers.length,
                itemBuilder: (context, index) {
                  final container = state.device.containers[index];
                  final GlobalKey key = GlobalKey();

                  return ListTile(
                    key: key,
                    title: Text(
                      'Container ${container.containerId}',
                      style: bodyTextStyle,
                    ),
                    subtitle: Text(
                      container.medicineName ?? 'Empty',
                      style: captionTextStyle,
                    ),
                    trailing: Text(
                      container.quantity.toString(),
                      style: captionTextStyle,
                    ),
                    onTap: () {
                      poopUpMenuContainer(context, container, key, 80);
                    },
                  );
                },
              );
            } else if (state is DeviceLoading) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 16,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 14,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                    ),
                    trailing: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 14,
                        width: 40,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              );
            } else if (state is DeviceError) {
              if (state.message == 'Exception: Device not found' ||
                  state.message == 'No device found') {
                return Column(
                  children: [
                    // Text(
                    // state.message,
                    //   style: bodyTextStyle,
                    // ),
                    // spacerHeight(20),
                    // add a button to add device
                    ElevatedButton(
                      onPressed: () {
                        // open a dialog to add device
                        showDialog(
                          context: context,
                          builder: (context) {
                            String deviceUid = '';
                            return AlertDialog(
                              title: const Text('Add Device'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    onChanged: (value) {
                                      deviceUid = value;
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Device UID',
                                      hintText: 'Enter device UID',
                                    ),
                                  ),
                                  // Add more fields if necessary
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    if (deviceUid.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Device UID cannot be empty'),
                                        ),
                                      );
                                      return;
                                    }
                                    if (userId == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('User ID is not available'),
                                        ),
                                      );
                                      return;
                                    }
                                    context.read<DeviceBloc>().add(
                                          DeviceAdd(
                                            userId!,
                                            deviceUid,
                                          ),
                                        );
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Add Device'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Add Device'),
                    ),
                  ],
                );
              }
              return Center(
                child: Text(
                  state.message,
                  style: bodyTextStyle,
                ),
              );
            } else {
              return const Text('No data available');
            }
          }),
        ]),
      ),
    );
  }
}
