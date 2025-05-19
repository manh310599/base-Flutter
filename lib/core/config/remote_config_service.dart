import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

/// Default values for remote config parameters.
class RemoteConfigDefaults {
  static const Map<String, dynamic> defaults = {
    'app_version': '1.0.0',
    'min_required_version': '1.0.0',
    'maintenance_mode': false,
    'maintenance_message': 'We are currently performing maintenance. Please try again later.',
    'feature_flags': '{"new_transfer_flow": false, "biometric_login": true}',
    'api_timeout_seconds': 30,
    'max_transaction_amount': 10000,
  };
}

/// Service for fetching and managing remote configuration.
@singleton
class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;
  final Logger _logger;

  RemoteConfigService(this._remoteConfig, this._logger);

  /// Initializes the remote config service.
  @PostConstruct()
  Future<void> init() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ));

      await _remoteConfig.setDefaults(RemoteConfigDefaults.defaults);
      await _remoteConfig.fetchAndActivate();
      
      _logger.i('Remote config initialized successfully');
    } catch (e) {
      _logger.e('Error initializing remote config: $e');
    }
  }

  /// Fetches the latest remote config values.
  Future<bool> fetch() async {
    try {
      await _remoteConfig.fetch();
      final activated = await _remoteConfig.activate();
      _logger.i('Remote config fetched and activated: $activated');
      return activated;
    } catch (e) {
      _logger.e('Error fetching remote config: $e');
      return false;
    }
  }

  /// Gets a string value from remote config.
  String getString(String key) {
    return _remoteConfig.getString(key);
  }

  /// Gets a boolean value from remote config.
  bool getBool(String key) {
    return _remoteConfig.getBool(key);
  }

  /// Gets an integer value from remote config.
  int getInt(String key) {
    return _remoteConfig.getInt(key);
  }

  /// Gets a double value from remote config.
  double getDouble(String key) {
    return _remoteConfig.getDouble(key);
  }

  /// Gets a map value from remote config.
  Map<String, dynamic> getMap(String key) {
    final jsonString = _remoteConfig.getString(key);
    try {
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      _logger.e('Error parsing remote config map: $e');
      return {};
    }
  }

  /// Gets a list value from remote config.
  List<dynamic> getList(String key) {
    final jsonString = _remoteConfig.getString(key);
    try {
      return json.decode(jsonString) as List<dynamic>;
    } catch (e) {
      _logger.e('Error parsing remote config list: $e');
      return [];
    }
  }

  /// Gets all remote config parameters.
  Map<String, RemoteConfigValue> getAll() {
    return _remoteConfig.getAll();
  }

  /// Gets a feature flag value from remote config.
  bool getFeatureFlag(String featureName) {
    final featureFlags = getMap('feature_flags');
    return featureFlags[featureName] as bool? ?? false;
  }

  /// Gets the app version from remote config.
  String getAppVersion() {
    return getString('app_version');
  }

  /// Gets the minimum required app version from remote config.
  String getMinRequiredVersion() {
    return getString('min_required_version');
  }

  /// Returns true if the app is in maintenance mode.
  bool isInMaintenanceMode() {
    return getBool('maintenance_mode');
  }

  /// Gets the maintenance message from remote config.
  String getMaintenanceMessage() {
    return getString('maintenance_message');
  }

  /// Gets the API timeout in seconds from remote config.
  int getApiTimeoutSeconds() {
    return getInt('api_timeout_seconds');
  }

  /// Gets the maximum transaction amount from remote config.
  double getMaxTransactionAmount() {
    return getDouble('max_transaction_amount');
  }
}
