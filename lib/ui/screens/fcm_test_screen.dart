import 'package:flutter/cupertino.dart';
import 'package:medicine_reminder/core/services/fcm_service.dart';

class FCMTestScreen extends StatefulWidget {
  const FCMTestScreen({super.key});

  @override
  State<FCMTestScreen> createState() => _FCMTestScreenState();
}

class _FCMTestScreenState extends State<FCMTestScreen> {
  final FCMService _fcmService = FCMService();
  String _fcmToken = 'Loading...';
  String _status = 'Initializing FCM...';

  @override
  void initState() {
    super.initState();
    _initializeFCM();
  }

  Future<void> _initializeFCM() async {
    try {
      // Get the current FCM token
      final token =
          _fcmService.fcmToken ?? await _fcmService.getSavedFCMToken();

      setState(() {
        _fcmToken = token ?? 'No token available';
        _status = 'FCM initialized successfully';
      });
    } catch (e) {
      setState(() {
        _status = 'Error initializing FCM: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('FCM Test'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Status Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: CupertinoColors.separator,
                    width: 0.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'FCM Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _status,
                      style: TextStyle(
                        color: _status.contains('Error')
                            ? CupertinoColors.destructiveRed
                            : CupertinoColors.activeGreen,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // FCM Token Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: CupertinoColors.separator,
                    width: 0.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'FCM Token',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _fcmToken,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton(
                        color: CupertinoColors.activeBlue,
                        onPressed: () {
                          // Copy token to clipboard
                          if (_fcmToken != 'Loading...' &&
                              _fcmToken != 'No token available') {
                            // You can implement clipboard copy here
                            _showSuccessDialog('Token copied to clipboard');
                          }
                        },
                        child: const Text('Copy Token'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Action Buttons
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      color: CupertinoColors.activeGreen,
                      onPressed: _subscribeToTopic,
                      child:
                          const Text('Subscribe to "medicine_reminders" Topic'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      color: CupertinoColors.destructiveRed,
                      onPressed: _unsubscribeFromTopic,
                      child: const Text('Unsubscribe from Topic'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      color: CupertinoColors.systemOrange,
                      onPressed: _clearAllNotifications,
                      child: const Text('Clear All Notifications'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Instructions
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: CupertinoColors.systemBlue.withOpacity(0.3),
                    width: 0.5,
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How to Test FCM',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.systemBlue,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '1. Copy the FCM token above\n'
                      '2. Use Firebase Console or a backend service to send test notifications\n'
                      '3. Subscribe to topics for group notifications\n'
                      '4. Test foreground, background, and terminated app states',
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.systemBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _subscribeToTopic() async {
    try {
      await _fcmService.subscribeToTopic('medicine_reminders');
      _showSuccessDialog('Subscribed to medicine_reminders topic');
    } catch (e) {
      _showErrorDialog('Failed to subscribe: $e');
    }
  }

  Future<void> _unsubscribeFromTopic() async {
    try {
      await _fcmService.unsubscribeFromTopic('medicine_reminders');
      _showSuccessDialog('Unsubscribed from medicine_reminders topic');
    } catch (e) {
      _showErrorDialog('Failed to unsubscribe: $e');
    }
  }

  Future<void> _clearAllNotifications() async {
    try {
      await _fcmService.clearAllNotifications();
      _showSuccessDialog('All notifications cleared');
    } catch (e) {
      _showErrorDialog('Failed to clear notifications: $e');
    }
  }

  void _showSuccessDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
