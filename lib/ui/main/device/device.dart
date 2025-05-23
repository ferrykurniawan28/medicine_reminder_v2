part of '../main.dart';

class DeviceView extends StatefulWidget {
  const DeviceView({super.key});

  @override
  State<DeviceView> createState() => _DeviceState();
}

// TODO: work on device
class _DeviceState extends State<DeviceView> {
  @override
  void initState() {
    super.initState();
    if (context.read<DeviceBloc>().device == null) {
      context.read<DeviceBloc>().add(DeviceFetch(1));
    } else {
      context.read<DeviceBloc>().add(DeviceRefresh());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar('Device', actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.playlist_remove))
      ]),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<DeviceBloc>().add(DeviceRefresh());
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
                      poopUpMenuContainer(context, container, key, 0);
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
              if (state.message == 'Device not found') {
                return Column(
                  children: [
                    Text(
                      state.message,
                      style: bodyTextStyle,
                    ),
                    spacerHeight(20),
                    // add a button to add device
                    ElevatedButton(
                      onPressed: () {
                        context.read<DeviceBloc>().add(const DeviceFetch(1));
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
