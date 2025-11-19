import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_reminder/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:medicine_reminder/features/notification/data/models/notification_model.dart';
import 'package:medicine_reminder/helpers/helpers.dart';
import 'package:medicine_reminder/helpers/notification_helper.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    // Initialize and load notifications when page opens
    NotificationHelper.loadNotifications(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar('Notifications'),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }

          if (state is NotificationError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.exclamationmark_triangle,
                    size: 64,
                    color: CupertinoColors.systemRed,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading notifications',
                    style: TextStyle(
                      fontSize: 18,
                      color: CupertinoColors.systemRed,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: const TextStyle(
                      color: CupertinoColors.systemGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  CupertinoButton.filled(
                    onPressed: () {
                      context.read<NotificationBloc>().add(LoadNotifications());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return const _EmptyNotificationsView();
            }

            return CustomScrollView(
              slivers: [
                // Unread notifications section
                if (state.unreadNotifications.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Text(
                            'Recent',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              context
                                  .read<NotificationBloc>()
                                  .add(MarkAllAsRead());
                            },
                            child: const Text(
                              'Mark all as read',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final notification = state.unreadNotifications[index];
                        return _NotificationCard(
                          notification: notification,
                          isUnread: true,
                          onTap: () =>
                              _onNotificationTap(context, notification),
                          onDismiss: () =>
                              _onNotificationDismiss(context, notification),
                        );
                      },
                      childCount: state.unreadNotifications.length,
                    ),
                  ),
                ],

                // All notifications section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      state.unreadNotifications.isNotEmpty
                          ? 'Earlier'
                          : 'All Notifications',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final notification = state.notifications[index];
                      return _NotificationCard(
                        notification: notification,
                        isUnread: false,
                        onTap: () => _onNotificationTap(context, notification),
                        onDismiss: () =>
                            _onNotificationDismiss(context, notification),
                      );
                    },
                    childCount: state.notifications.length,
                  ),
                ),
              ],
            );
          }

          return const Center(
            child: CupertinoActivityIndicator(),
          );
        },
      ),
    );
  }

  void _onNotificationTap(
      BuildContext context, NotificationModel notification) {
    // Mark as read
    context.read<NotificationBloc>().add(MarkAsRead(notification.id));

    // Handle notification navigation based on type
    switch (notification.type) {
      case NotificationType.medicineReminder:
        // Navigate to medicine reminder details
        break;
      case NotificationType.appointmentReminder:
        // Navigate to appointment details
        break;
      case NotificationType.deviceAlert:
        // Navigate to device management
        break;
      case NotificationType.parentalAlert:
        // Navigate to parental dashboard
        break;
      default:
        // Default action
        break;
    }
  }

  void _onNotificationDismiss(
      BuildContext context, NotificationModel notification) {
    context.read<NotificationBloc>().add(DeleteNotification(notification.id));
  }

  void _showNotificationSettings(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Notification Settings'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to notification preferences
            },
            child: const Text('Notification Preferences'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              context.read<NotificationBloc>().add(ClearAllNotifications());
            },
            child: const Text('Clear All Notifications'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }
}

class _EmptyNotificationsView extends StatelessWidget {
  const _EmptyNotificationsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.bell_slash,
            size: 64,
            color: CupertinoColors.systemGrey.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.systemGrey.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'ll let you know when something important happens',
            style: TextStyle(
              fontSize: 16,
              color: CupertinoColors.systemGrey.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final bool isUnread;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationCard({
    required this.notification,
    required this.isUnread,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isUnread
            ? CupertinoColors.systemBlue.withOpacity(0.1)
            : CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnread
              ? CupertinoColors.systemBlue.withOpacity(0.3)
              : CupertinoColors.separator,
          width: 0.5,
        ),
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Notification icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color:
                      _getNotificationColor(notification.type).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  _getNotificationIcon(notification.type),
                  color: _getNotificationColor(notification.type),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),

              // Notification content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  isUnread ? FontWeight.w600 : FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: CupertinoColors.systemBlue,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.systemGrey.withOpacity(0.8),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatTime(notification.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemGrey.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),

              // Dismiss button
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: onDismiss,
                child: Icon(
                  CupertinoIcons.xmark_circle_fill,
                  color: CupertinoColors.systemGrey.withOpacity(0.6),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.medicineReminder:
        return CupertinoIcons.capsule;
      case NotificationType.appointmentReminder:
        return CupertinoIcons.calendar;
      case NotificationType.deviceAlert:
        return CupertinoIcons.device_phone_portrait;
      case NotificationType.parentalAlert:
        return CupertinoIcons.person_2;
      default:
        return CupertinoIcons.bell;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.medicineReminder:
        return CupertinoColors.systemGreen;
      case NotificationType.appointmentReminder:
        return CupertinoColors.systemBlue;
      case NotificationType.deviceAlert:
        return CupertinoColors.systemOrange;
      case NotificationType.parentalAlert:
        return CupertinoColors.systemPurple;
      case NotificationType.fcmTest:
        return CupertinoColors.systemIndigo;
      default:
        return CupertinoColors.systemGrey;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
