import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

@singleton
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  ConnectivityService() {
    _initialize();
  }

  void _initialize() {
    // Initialize the connectivity subscription
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      // Handle connectivity changes
      _handleConnectivityChange(results);
    });
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    // Log connectivity change for debugging (remove in production)
    // Connectivity changed: $results

    // You can add additional logic here if needed
    // For example, showing a snackbar when connection is restored
  }

  /// Check current connectivity status
  Future<List<ConnectivityResult>> checkConnectivity() async {
    try {
      return await _connectivity.checkConnectivity();
    } catch (e) {
      // Error checking connectivity: $e
      return [ConnectivityResult.none];
    }
  }

  /// Get connectivity stream
  Stream<List<ConnectivityResult>> get connectivityStream =>
      _connectivity.onConnectivityChanged;

  /// Check if device is connected to internet
  bool isConnected(List<ConnectivityResult> results) {
    return results.isNotEmpty &&
        !results.contains(ConnectivityResult.none) &&
        results.any(
          (result) =>
              result == ConnectivityResult.mobile ||
              result == ConnectivityResult.wifi ||
              result == ConnectivityResult.ethernet ||
              result == ConnectivityResult.vpn,
        );
  }

  /// Check if device is connected to WiFi
  bool isConnectedToWiFi(List<ConnectivityResult> results) {
    return results.contains(ConnectivityResult.wifi);
  }

  /// Check if device is connected to Mobile data
  bool isConnectedToMobile(List<ConnectivityResult> results) {
    return results.contains(ConnectivityResult.mobile);
  }

  /// Get connection type as string
  String getConnectionType(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return 'No Connection';
    }

    if (results.contains(ConnectivityResult.wifi)) {
      return 'WiFi';
    }

    if (results.contains(ConnectivityResult.mobile)) {
      return 'Mobile Data';
    }

    if (results.contains(ConnectivityResult.ethernet)) {
      return 'Ethernet';
    }

    if (results.contains(ConnectivityResult.vpn)) {
      return 'VPN';
    }

    return 'Unknown';
  }

  /// Dispose of the service
  void dispose() {
    _connectivitySubscription.cancel();
  }
}
