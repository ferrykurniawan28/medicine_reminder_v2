import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_reminder/core/connectivity/connectivity_service.dart';
import 'package:medicine_reminder/features/notification/presentation/bloc/notification_bloc.dart';

/// Debug widget to help with testing notification performance and connectivity
/// Shows real-time status of connectivity and notification counts
class NotificationTestDebugPanel extends StatelessWidget {
  const NotificationTestDebugPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: Colors.black87,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.bug_report, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Debug Panel',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () {
                    context.read<NotificationBloc>().add(LoadNotifications());
                  },
                  tooltip: 'Refresh notifications',
                ),
              ],
            ),
            const Divider(color: Colors.grey),
            const SizedBox(height: 8),

            // Connectivity Status
            _buildConnectionStatus(context),
            const SizedBox(height: 12),

            // Notification Stats
            _buildNotificationStats(context),
            const SizedBox(height: 12),

            // Quick Actions
            _buildQuickActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionStatus(BuildContext context) {
    final isOnline = ConnectivityService().isConnected;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isOnline ? Colors.green.shade900 : Colors.red.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            isOnline ? Icons.wifi : Icons.wifi_off,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connection: ${isOnline ? "ONLINE" : "OFFLINE"}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Status: ${isOnline ? "Connected to server" : "Using local data"}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            DateTime.now().toString().substring(11, 19),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationStats(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state is NotificationLoaded) {
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade900,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildStatRow(
                  'Total Notifications',
                  state.notifications.length.toString(),
                  Icons.notifications,
                ),
                const Divider(color: Colors.white24, height: 16),
                _buildStatRow(
                  'Unread',
                  state.unreadNotifications.length.toString(),
                  Icons.notification_important,
                ),
                const Divider(color: Colors.white24, height: 16),
                _buildStatRow(
                  'Read',
                  (state.notifications.length -
                          state.unreadNotifications.length)
                      .toString(),
                  Icons.check_circle,
                ),
              ],
            ),
          );
        } else if (state is NotificationLoading) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Loading notifications...',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          );
        } else if (state is NotificationError) {
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.shade900,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.error, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'No notification data',
            style: TextStyle(color: Colors.white70),
          ),
        );
      },
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<NotificationBloc>().add(RefreshNotifications());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Syncing with server...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.sync, size: 16),
                label: const Text('Sync', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<NotificationBloc>().add(MarkAllAsRead());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Marking all as read...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.done_all, size: 16),
                label: const Text('Read All', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              _showTestInfo(context);
            },
            icon: const Icon(Icons.info_outline, size: 16),
            label: const Text('Show Test Info', style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  void _showTestInfo(BuildContext context) {
    final notificationState = context.read<NotificationBloc>().state;
    final isOnline = ConnectivityService().isConnected;
    final userId = context.read<NotificationBloc>().userId;

    String info = '''
📊 Test Information
━━━━━━━━━━━━━━━━━━━━━━

🔌 Connection Status: ${isOnline ? "✅ ONLINE" : "❌ OFFLINE"}
👤 User ID: $userId
⏰ Time: ${DateTime.now().toString().substring(0, 19)}

''';

    if (notificationState is NotificationLoaded) {
      info += '''
📬 Notification Stats:
  • Total: ${notificationState.notifications.length}
  • Unread: ${notificationState.unreadNotifications.length}
  • Read: ${notificationState.notifications.length - notificationState.unreadNotifications.length}

📋 Latest Notifications:
''';

      final latest = notificationState.notifications.take(3).toList();
      for (var i = 0; i < latest.length; i++) {
        final notif = latest[i];
        info += '''
  ${i + 1}. ${notif.title}
     Type: ${notif.type.name}
     Time: ${notif.createdAt.toString().substring(0, 19)}
     Read: ${notif.isRead ? "✅" : "❌"}
''';
      }
    } else if (notificationState is NotificationError) {
      info += '\n❌ Error: ${notificationState.message}';
    } else if (notificationState is NotificationLoading) {
      info += '\n⏳ Loading...';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Test Information'),
        content: SingleChildScrollView(
          child: Text(
            info,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              // Copy to clipboard would go here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Info copied to logs')),
              );
              print('=== TEST INFO ===');
              print(info);
              print('=================');
            },
            child: const Text('Copy to Logs'),
          ),
        ],
      ),
    );
  }
}
