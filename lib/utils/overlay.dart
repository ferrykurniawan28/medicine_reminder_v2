import 'package:flutter/material.dart';
import 'package:medicine_reminder/helpers/helpers.dart';

class CustomOverlay {
  static OverlayEntry? _currentOverlay;

  static void show(BuildContext context, Widget child) {
    if (_currentOverlay != null) return; // Prevent multiple overlays

    _currentOverlay = OverlayEntry(
      builder: (context) => Scaffold(
        backgroundColor: Colors.black54,
        body: GestureDetector(
          onTap: hide, // Hide the overlay when tapped
          child: Center(child: child),
        ),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final overlay = Overlay.of(context);
      overlay.insert(_currentOverlay!);
    });
  }

  static void hide({VoidCallback? onDismiss}) {
    _currentOverlay?.remove();
    _currentOverlay = null;
    if (onDismiss != null) onDismiss();
  }

  static void showLoading(BuildContext context, {String? message}) {
    show(
      context,
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
            ),
            const SizedBox(height: 16),
            if (message != null)
              Text(
                message,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
          ],
        ),
      ),
    );
  }
}
