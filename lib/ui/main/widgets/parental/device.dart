part of '../widgets.dart';

class DeviceParental extends StatefulWidget {
  final Parental parental;
  const DeviceParental({super.key, required this.parental});

  @override
  State<DeviceParental> createState() => _DeviceParentalState();
}

class _DeviceParentalState extends State<DeviceParental> {
  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    context
        .read<ParentalBloc>()
        .add(const LoadDeviceParental(1)); //Todo: get the id from the parental
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadDevices,
      child: BlocBuilder<ParentalBloc, ParentalState>(
        builder: (context, state) {
          if (state is DeviceParentalLoaded) {
            if (state.devices == null) {
              return const Center(
                child: Text('No devices found add one!'),
              );
            }
            return ListView(
              padding: const EdgeInsets.all(8),
              children: [
                BlocBuilder<ParentalBloc, ParentalState>(
                  builder: (context, state) {
                    if (state is DeviceParentalLoaded) {
                      return YourDevice(device: state.devices);
                    } else if (state is ParentalLoading) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Column(
                          children: List.generate(2, (index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                height: 100,
                                width: double.infinity,
                                color: Colors.white,
                              ),
                            );
                          }),
                        ),
                      );
                    } else {
                      return const Center(child: Text('No devices found'));
                    }
                  },
                ),
                spacerHeight(20),
                BlocBuilder<ParentalBloc, ParentalState>(
                  builder: (context, state) {
                    if (state is DeviceParentalLoaded) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.devices.containers.length,
                        itemBuilder: (context, index) {
                          final container = state.devices.containers[index];
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
                              poopUpMenuContainer(context, container, key, 110);
                            },
                          );
                        },
                      );
                    } else if (state is ParentalLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return const Center(child: Text('No devices found'));
                  },
                )
              ],
            );
          } else if (state is ParentalLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('No devices found'));
          }
        },
      ),
    );
  }
}
