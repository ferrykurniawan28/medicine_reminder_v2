import 'package:flutter/material.dart';
import 'connectivity_service.dart';

class ConnectivityBanner extends StatefulWidget {
  final Widget child;
  final bool showWhenConnected;
  final Duration animationDuration;

  const ConnectivityBanner({
    super.key,
    required this.child,
    this.showWhenConnected = false,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends State<ConnectivityBanner>
    with SingleTickerProviderStateMixin {
  late final ConnectivityService _connectivityService;
  late final AnimationController _animationController;
  late final Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _connectivityService = ConnectivityService();

    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _connectivityService.connectionStream,
      initialData: _connectivityService.isConnected,
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? false;
        final shouldShow =
            widget.showWhenConnected ? isConnected : !isConnected;

        if (shouldShow) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }

        return Stack(
          alignment: Alignment.topCenter, // Use non-directional alignment
          children: [
            widget.child,
            // if (shouldShow)
            //   Positioned(
            //     top: 0,
            //     left: 0,
            //     right: 0,
            //     child: AnimatedContainer(
            //       duration: widget.animationDuration,
            //       curve: Curves.easeOut,
            //       transform: Matrix4.translationValues(
            //           0, _slideAnimation.value * 50, 0),
            //       child: Container(
            //         width: double.infinity,
            //         height: 50,
            //         padding: const EdgeInsets.symmetric(
            //           horizontal: 16,
            //           vertical: 8,
            //         ),
            //         color: isConnected ? Colors.green : Colors.red,
            //         child: SafeArea(
            //           bottom: false,
            //           child: Row(
            //             children: [
            //               Icon(
            //                 isConnected ? Icons.wifi : Icons.wifi_off,
            //                 color: Colors.white,
            //                 size: 16,
            //               ),
            //               const SizedBox(width: 8),
            //               Expanded(
            //                 child: Text(
            //                   _connectivityService.statusMessage,
            //                   style: const TextStyle(
            //                     color: Colors.white,
            //                     fontSize: 12,
            //                     fontWeight: FontWeight.w500,
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
          ],
        );
      },
    );
  }
}

class ConnectivityIndicator extends StatelessWidget {
  final double size;
  final bool showText;

  const ConnectivityIndicator({
    super.key,
    this.size = 24,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    final connectivityService = ConnectivityService();

    return StreamBuilder<bool>(
      stream: connectivityService.connectionStream,
      initialData: connectivityService.isConnected,
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? false;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isConnected ? Icons.wifi : Icons.wifi_off,
              size: size,
              color: isConnected ? Colors.white : Colors.red,
            ),
            if (showText) ...[
              const SizedBox(width: 4),
              Text(
                connectivityService.getConnectionStatusText(),
                style: TextStyle(
                  fontSize: size * 0.6,
                  color: isConnected ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class ConnectivityListener extends StatefulWidget {
  final Widget child;
  final VoidCallback? onConnected;
  final VoidCallback? onDisconnected;
  final bool showSnackBar;

  const ConnectivityListener({
    super.key,
    required this.child,
    this.onConnected,
    this.onDisconnected,
    this.showSnackBar = true,
  });

  @override
  State<ConnectivityListener> createState() => _ConnectivityListenerState();
}

class _ConnectivityListenerState extends State<ConnectivityListener> {
  late final ConnectivityService _connectivityService;
  bool? _previousConnectionState;

  @override
  void initState() {
    super.initState();
    _connectivityService = ConnectivityService();
    _previousConnectionState = _connectivityService.isConnected;
  }

  void _showConnectivitySnackBar(bool isConnected) {
    if (!widget.showSnackBar) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isConnected ? Icons.wifi : Icons.wifi_off,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(_connectivityService.statusMessage),
          ],
        ),
        backgroundColor: isConnected ? Colors.green : Colors.red,
        duration: Duration(seconds: isConnected ? 2 : 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _connectivityService.connectionStream,
      initialData: _connectivityService.isConnected,
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? false;

        // Handle connection state changes
        if (_previousConnectionState != null &&
            _previousConnectionState != isConnected) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (isConnected) {
              widget.onConnected?.call();
            } else {
              widget.onDisconnected?.call();
            }

            _showConnectivitySnackBar(isConnected);
          });
        }

        _previousConnectionState = isConnected;

        return widget.child;
      },
    );
  }
}

/// A simple button to manually refresh connectivity status
class ConnectivityRefreshButton extends StatelessWidget {
  final VoidCallback? onRefresh;

  const ConnectivityRefreshButton({
    super.key,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final connectivityService = ConnectivityService();

    return IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: () async {
        await connectivityService.refreshStatus();
        onRefresh?.call();
      },
      tooltip: 'Refresh connectivity status',
    );
  }
}
