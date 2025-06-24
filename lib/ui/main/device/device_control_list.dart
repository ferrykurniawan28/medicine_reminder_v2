part of '../main.dart';

class DeviceControlList extends StatefulWidget {
  const DeviceControlList({super.key});

  @override
  State<DeviceControlList> createState() => _DeviceControlListState();
}

class _DeviceControlListState extends State<DeviceControlList> {
  bool _isFetching = false; // Flag to prevent duplicate fetches
  int? userId;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserId();
    });
  }

  // Fetch userId from shared preferences
  Future<void> _fetchUserId() async {
    if (_isFetching) {
      return;
    }

    _isFetching = true; // Set fetching flag to true

    try {
      userId = await SharedPreference.getInt('userId');

      if (userId == null) {
        return;
      }

      if (!mounted) return;

      context.read<DeviceBloc>().add(DeviceControlFetch());
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching device: $e'),
        ),
      );
    } finally {
      _isFetching = false; // Reset fetching flag
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(
        'Device Control List',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<DeviceBloc>().add(DeviceFetch(userId!));
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocBuilder<DeviceBloc, DeviceState>(
        builder: (context, state) {
          if (state is DeviceLoading) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            );
          } else if (state is DeviceError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Error occurred',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: kAccentColor.withOpacity(0.8),
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {
                      context.read<DeviceBloc>().add(DeviceControlFetch());
                    },
                    child: const Text(
                      'Retry',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is DeviceControlLoaded) {
            final deviceControls = state.deviceControls;
            if (deviceControls.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.devices_other,
                        size: 64, color: kAccentColor.withOpacity(0.5)),
                    const SizedBox(height: 16),
                    Text(
                      'No device controls found',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: kAccentColor,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add a new control to get started',
                      style: TextStyle(color: kSecondaryColor.withOpacity(0.7)),
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: deviceControls.length,
              separatorBuilder: (context, index) => Divider(
                height: 16,
                color: kAccentColor.withOpacity(0.1),
              ),
              itemBuilder: (context, index) {
                final control = deviceControls[index];
                return Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: kAccentColor.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      // Add onTap functionality if needed
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  control.action.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: kPrimaryColor,
                                        letterSpacing: 0.5,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(control.status),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  control.status.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (control.medicineName != null) ...[
                            _buildInfoRow(
                              context,
                              icon: Icons.medication,
                              label: 'Medicine',
                              value: control.medicineName!,
                              color: kSecondaryColor,
                            ),
                            const SizedBox(height: 4),
                          ],
                          if (control.quantity != null) ...[
                            _buildInfoRow(
                              context,
                              icon: Icons.format_list_numbered,
                              label: 'Quantity',
                              value: control.quantity.toString(),
                              color: kSecondaryColor,
                            ),
                            const SizedBox(height: 4),
                          ],
                          if (control.notes?.isNotEmpty ?? false) ...[
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              context,
                              icon: Icons.notes,
                              label: 'Notes',
                              value: control.notes!,
                              color: kAccentColor,
                            ),
                          ],
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            context,
                            icon: Icons.person,
                            label: 'Requested by',
                            value: control.requestedBy.userName ?? 'Unknown',
                            color: kAccentColor.withOpacity(0.7),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline,
                    size: 48, color: kAccentColor.withOpacity(0.5)),
                const SizedBox(height: 16),
                Text(
                  'No data available',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: kAccentColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Helper widget for consistent info rows
Widget _buildInfoRow(
  BuildContext context, {
  required IconData icon,
  required String label,
  required String value,
  required Color color,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 18, color: color),
      const SizedBox(width: 8),
      Expanded(
        child: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              TextSpan(
                text: '$label: ',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: kAccentColor,
                ),
              ),
              TextSpan(
                text: value,
                style: const TextStyle(color: kSecondaryColor),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

// Helper function to get status color with your palette
Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return kAccentColor.withOpacity(0.8);
    case 'completed':
      return kPrimaryColor;
    case 'failed':
      return Colors.red;
    default:
      return kSecondaryColor;
  }
}
