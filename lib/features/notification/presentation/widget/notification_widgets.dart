import 'package:flutter/cupertino.dart';
import 'package:medicine_reminder/features/notification/data/models/notification_model.dart';

class NotificationBadge extends StatelessWidget {
  final int count;
  final Color? color;
  final double? size;

  const NotificationBadge({
    super.key,
    required this.count,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color ?? CupertinoColors.systemRed,
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: BoxConstraints(
        minWidth: size ?? 20,
        minHeight: size ?? 20,
      ),
      child: Center(
        child: Text(
          count > 99 ? '99+' : count.toString(),
          style: TextStyle(
            color: CupertinoColors.white,
            fontSize: (size ?? 20) * 0.6,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class NotificationIcon extends StatelessWidget {
  final NotificationType type;
  final double? size;
  final Color? color;

  const NotificationIcon({
    super.key,
    required this.type,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      _getIconData(type),
      size: size ?? 24,
      color: color ?? _getDefaultColor(type),
    );
  }

  IconData _getIconData(NotificationType type) {
    switch (type) {
      case NotificationType.medicineReminder:
        return CupertinoIcons.capsule;
      case NotificationType.appointmentReminder:
        return CupertinoIcons.calendar;
      case NotificationType.deviceAlert:
        return CupertinoIcons.device_phone_portrait;
      case NotificationType.parentalAlert:
        return CupertinoIcons.person_2;
      case NotificationType.fcmTest:
        return CupertinoIcons.lab_flask;
      case NotificationType.general:
        return CupertinoIcons.bell;
    }
  }

  Color _getDefaultColor(NotificationType type) {
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
      case NotificationType.general:
        return CupertinoColors.systemGrey;
    }
  }
}

class NotificationTypeFilter extends StatelessWidget {
  final NotificationType? selectedType;
  final Function(NotificationType?) onTypeSelected;

  const NotificationTypeFilter({
    super.key,
    this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _FilterChip(
            label: 'All',
            isSelected: selectedType == null,
            onTap: () => onTypeSelected(null),
          ),
          const SizedBox(width: 8),
          ...NotificationType.values.map(
            (type) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _FilterChip(
                label: type.displayName,
                isSelected: selectedType == type,
                onTap: () => onTypeSelected(type),
                icon: NotificationIcon(type: type, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget? icon;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? CupertinoColors.systemBlue
              : CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color:
                    isSelected ? CupertinoColors.white : CupertinoColors.label,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationQuickActions extends StatelessWidget {
  final VoidCallback onMarkAllRead;
  final VoidCallback onClearAll;
  final VoidCallback onSettings;

  const NotificationQuickActions({
    super.key,
    required this.onMarkAllRead,
    required this.onClearAll,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              icon: CupertinoIcons.checkmark_circle,
              label: 'Mark All Read',
              onTap: onMarkAllRead,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ActionButton(
              icon: CupertinoIcons.clear,
              label: 'Clear All',
              onTap: onClearAll,
              isDestructive: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ActionButton(
              icon: CupertinoIcons.settings,
              label: 'Settings',
              onTap: onSettings,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isDestructive
              ? CupertinoColors.systemRed.withOpacity(0.1)
              : CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDestructive
                ? CupertinoColors.systemRed.withOpacity(0.3)
                : CupertinoColors.separator,
            width: 0.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isDestructive
                  ? CupertinoColors.systemRed
                  : CupertinoColors.systemBlue,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDestructive
                    ? CupertinoColors.systemRed
                    : CupertinoColors.label,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
