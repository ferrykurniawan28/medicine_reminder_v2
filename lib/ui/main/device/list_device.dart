part of '../main.dart';

class ListDevice extends StatelessWidget {
  const ListDevice({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<DeviceBloc>().add(const DevicesFetch(1));
    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop && result != null) {
          context.read<DeviceBloc>().add(DeviceRefresh());
        }
      },
      child: Scaffold(
        appBar: defaultAppBar('Devices List', actions: [
          IconButton(
            onPressed: () {
              // Modular.to.pushNamed('/device/add');
            },
            icon: const Icon(Icons.add),
          )
        ]),
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<DeviceBloc>().add(DeviceRefresh());
          },
          child: ListView(children: [
            BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
              if (state is DevicesLoaded) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.devices.length,
                  itemBuilder: (context, index) {
                    final device = state.devices[index];
                    return ListTile(
                      leading: Image.asset(
                        'assets/icons/device.png',
                        width: 36,
                      ),
                      title: Text(
                        device.uuid,
                        style: bodyTextStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // subtitle: Text(
                      //   device.deviceId,
                      //   style: captionTextStyle,
                      // ),
                      onTap: () {
                        context
                            .read<DeviceBloc>()
                            .add(LoadDeviceDetail(device));
                        Modular.to.pushNamed('/device/${device.id}');
                      },
                    );
                  },
                );
              }
              // context.read<DeviceBloc>().add(const DevicesFetch(1));
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 36,
                        height: 36,
                        color: Colors.white,
                      ),
                    ),
                    title: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 16,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 12,
                        color: Colors.white,
                        margin: const EdgeInsets.only(top: 4),
                      ),
                    ),
                    onTap: () {},
                  );
                },
              );
            }),
          ]),
        ),
      ),
    );
  }
}
