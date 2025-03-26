part of '../main.dart';

class Device extends StatefulWidget {
  final int deviceId;
  const Device({super.key, required this.deviceId});

  @override
  State<Device> createState() => _DeviceState();
}

class _DeviceState extends State<Device> {
  @override
  void initState() {
    super.initState();
    context.read<DeviceBloc>().add(DeviceFetch(widget.deviceId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar('Device',
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Modular.to.pop();
              context.read<DeviceBloc>().add(const DevicesFetch(1));
            },
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
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
                  children: List.generate(3, (index) {
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
                      // poopUpMenuContainer(context, container, key);
                    },
                  );
                },
              );
            } else if (state is DeviceLoading) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5, // Placeholder shimmer items
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
            }
            return const SizedBox();
          }),
        ]),
      ),
    );
  }
}
