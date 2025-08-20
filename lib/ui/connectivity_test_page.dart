import 'package:flutter/material.dart';
import '../core/connectivity/connectivity.dart';

class ConnectivityTestPage extends StatelessWidget {
  const ConnectivityTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final connectivityService = ConnectivityService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connectivity Test'),
        actions: [
          ConnectivityRefreshButton(
            onRefresh: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Connectivity refreshed!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Connectivity Status',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    const ConnectivityIndicator(size: 24, showText: true),
                    const SizedBox(height: 16),
                    StreamBuilder<bool>(
                      stream: connectivityService.connectionStream,
                      initialData: connectivityService.isConnected,
                      builder: (context, snapshot) {
                        final isConnected = snapshot.data ?? false;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Connected: ${isConnected ? "Yes" : "No"}'),
                            Text(
                                'Connection Type: ${connectivityService.currentResult.name}'),
                            Text(
                                'Status Message: ${connectivityService.statusMessage}'),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  isConnected
                                      ? Icons.check_circle
                                      : Icons.error,
                                  color:
                                      isConnected ? Colors.green : Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isConnected
                                      ? 'Online features available'
                                      : 'Offline mode active',
                                  style: TextStyle(
                                    color:
                                        isConnected ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Feature Availability',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    StreamBuilder<bool>(
                      stream: connectivityService.connectionStream,
                      initialData: connectivityService.isConnected,
                      builder: (context, snapshot) {
                        return Column(
                          children: [
                            _buildFeatureRow(
                                'Sync Data', connectivityService.canSyncData),
                            _buildFeatureRow('Fetch Updates',
                                connectivityService.canFetchUpdates),
                            _buildFeatureRow('Upload Files',
                                connectivityService.canUploadFiles),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Actions',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        connectivityService.refreshStatus();
                      },
                      child: const Text('Manual Refresh'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: connectivityService.isConnected
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Simulating sync operation...'),
                                ),
                              );
                            }
                          : null,
                      child: const Text('Sync Data'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String feature, bool available) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            available ? Icons.check : Icons.close,
            color: available ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(feature),
          const Spacer(),
          Text(
            available ? 'Available' : 'Unavailable',
            style: TextStyle(
              color: available ? Colors.green : Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
