import 'package:flutter/material.dart';

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
}
