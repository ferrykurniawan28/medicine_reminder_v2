import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  // Stream controllers for broadcasting connectivity changes
  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();
  final StreamController<ConnectivityResult> _connectivityController =
      StreamController<ConnectivityResult>.broadcast();

  // Current connection status
  bool _isConnected = false;
  ConnectivityResult _currentResult = ConnectivityResult.none;

  // Getters
  bool get isConnected => _isConnected;
  ConnectivityResult get currentResult => _currentResult;
  Stream<bool> get connectionStream => _connectionController.stream;
  Stream<ConnectivityResult> get connectivityStream =>
      _connectivityController.stream;

  /// Initialize the connectivity service
  Future<void> initialize() async {
    try {
      // Get initial connectivity status
      final results = await _connectivity.checkConnectivity();
      _currentResult = _getHighestPriorityConnection(results);
      _isConnected = _isConnectionActive(_currentResult);

      // Listen for connectivity changes
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        _onConnectivityChanged,
        onError: (error) {
          debugPrint('Connectivity Service Error: $error');
        },
      );

      debugPrint(
          'Connectivity Service initialized. Initial status: $_currentResult');
    } catch (e) {
      debugPrint('Failed to initialize connectivity service: $e');
    }
  }

  /// Handle connectivity changes
  void _onConnectivityChanged(List<ConnectivityResult> results) {
    _currentResult = _getHighestPriorityConnection(results);
    final wasConnected = _isConnected;
    _isConnected = _isConnectionActive(_currentResult);

    debugPrint(
        'Connectivity changed: $results (Active: $_currentResult, Connected: $_isConnected)');

    // Broadcast the changes
    _connectionController.add(_isConnected);
    _connectivityController.add(_currentResult);

    // Log connection state changes
    if (wasConnected != _isConnected) {
      if (_isConnected) {
        debugPrint('🟢 Internet connection restored');
        _onConnectionRestored();
      } else {
        debugPrint('🔴 Internet connection lost');
        _onConnectionLost();
      }
    }
  }

  /// Get the highest priority connection from the list
  ConnectivityResult _getHighestPriorityConnection(
      List<ConnectivityResult> results) {
    if (results.isEmpty) return ConnectivityResult.none;

    // Priority order: ethernet > wifi > mobile > other > none
    if (results.contains(ConnectivityResult.ethernet))
      return ConnectivityResult.ethernet;
    if (results.contains(ConnectivityResult.wifi))
      return ConnectivityResult.wifi;
    if (results.contains(ConnectivityResult.mobile))
      return ConnectivityResult.mobile;
    if (results.contains(ConnectivityResult.vpn)) return ConnectivityResult.vpn;
    if (results.contains(ConnectivityResult.bluetooth))
      return ConnectivityResult.bluetooth;
    if (results.contains(ConnectivityResult.other))
      return ConnectivityResult.other;

    return ConnectivityResult.none;
  }

  /// Check if the current connection type indicates active internet
  bool _isConnectionActive(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.ethernet:
        return true;
      case ConnectivityResult.none:
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.vpn:
      case ConnectivityResult.other:
        return false;
    }
  }

  /// Called when connection is restored
  void _onConnectionRestored() {
    // You can add custom logic here, such as:
    // - Triggering sync operations
    // - Showing success messages
    // - Resuming network-dependent features
  }

  /// Called when connection is lost
  void _onConnectionLost() {
    // You can add custom logic here, such as:
    // - Showing offline messages
    // - Enabling offline mode
    // - Caching user actions
  }

  /// Get a human-readable connection status
  String getConnectionStatusText() {
    if (!_isConnected) return 'Offline';

    switch (_currentResult) {
      case ConnectivityResult.wifi:
        return 'Connected via WiFi';
      case ConnectivityResult.mobile:
        return 'Connected via Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Connected via Ethernet';
      default:
        return 'Online';
    }
  }

  /// Get connection icon based on status
  String getConnectionIcon() {
    if (!_isConnected) return '📵';

    switch (_currentResult) {
      case ConnectivityResult.wifi:
        return '📶';
      case ConnectivityResult.mobile:
        return '📱';
      case ConnectivityResult.ethernet:
        return '🔌';
      default:
        return '🌐';
    }
  }

  /// Check if specific features requiring internet are available
  bool get canSyncData => _isConnected;
  bool get canFetchUpdates => _isConnected;
  bool get canUploadFiles => _isConnected;

  /// Manually refresh connectivity status
  Future<void> refreshStatus() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _onConnectivityChanged(results);
    } catch (e) {
      debugPrint('Failed to refresh connectivity status: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectionController.close();
    _connectivityController.close();
  }
}

/// Extension for easier access to connectivity service
extension ConnectivityExtension on ConnectivityService {
  /// Show a snackbar or toast message about connectivity status
  String get statusMessage {
    return _isConnected
        ? '✅ ${getConnectionStatusText()}'
        : '❌ No internet connection';
  }

  /// Check if we should show offline indicator
  bool get shouldShowOfflineIndicator => !_isConnected;

  /// Check if we should allow network operations
  bool get allowNetworkOperations => _isConnected;
}
