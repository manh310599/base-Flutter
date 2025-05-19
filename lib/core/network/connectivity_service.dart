import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rxdart/rxdart.dart';

enum NetworkStatus {
  online,
  offline,
  cellular,
}

@singleton
class ConnectivityService {
  final Connectivity _connectivity;
  final InternetConnectionChecker _connectionChecker;

  // Stream controller for network status
  final BehaviorSubject<NetworkStatus> _networkStatusController =
      BehaviorSubject<NetworkStatus>();

  // Subscription to connectivity changes
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  ConnectivityService(this._connectivity, this._connectionChecker) {
    _initConnectivity();
    _setupConnectivityListener();
  }

  // Get the current network status
  Stream<NetworkStatus> get networkStatus => _networkStatusController.stream;

  // Initialize connectivity
  Future<void> _initConnectivity() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      await _updateConnectionStatus(connectivityResult);
    } catch (e) {
      // If we can't determine connectivity, assume offline
      _networkStatusController.add(NetworkStatus.offline);
    }
  }

  // Listen for connectivity changes
  void _setupConnectivityListener() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  // Update connection status based on connectivity result
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      _networkStatusController.add(NetworkStatus.offline);
      return;
    }

    // Check if we actually have internet
    final hasInternet = await _connectionChecker.hasConnection;

    if (!hasInternet) {
      _networkStatusController.add(NetworkStatus.offline);
      return;
    }

    // Determine if we're on cellular or WiFi
    if (result == ConnectivityResult.mobile) {
      _networkStatusController.add(NetworkStatus.cellular);
    } else {
      _networkStatusController.add(NetworkStatus.online);
    }
  }

  // Check if currently online
  Future<bool> isOnline() async {
    return await _connectionChecker.hasConnection;
  }

  // Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _networkStatusController.close();
  }
}
