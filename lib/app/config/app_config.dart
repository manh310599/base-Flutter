import 'package:injectable/injectable.dart';

import 'environment.dart';
import 'flavor_config.dart';

/// Application configuration based on environment
@singleton
class AppConfig {
  final AppEnvironment environment;
  final String apiBaseUrl;
  final String appName;
  final bool enableLogging;
  final bool enableCrashlytics;
  final bool enablePerformanceMonitoring;
  final int sessionTimeoutMinutes;
  final bool enableBiometrics;
  final bool enableSSLPinning;
  final int maxOfflineCacheDays;

  AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.appName,
    required this.enableLogging,
    required this.enableCrashlytics,
    required this.enablePerformanceMonitoring,
    required this.sessionTimeoutMinutes,
    required this.enableBiometrics,
    required this.enableSSLPinning,
    required this.maxOfflineCacheDays,
  });

  /// Create config from flavor
  factory AppConfig.fromFlavor(FlavorConfig flavorConfig) {
    switch (flavorConfig.environment) {
      case AppEnvironment.development:
        return AppConfig(
          environment: AppEnvironment.development,
          apiBaseUrl: 'https://dev-api.yourbank.com/v1',
          appName: 'Your Bank Dev',
          enableLogging: true,
          enableCrashlytics: false,
          enablePerformanceMonitoring: false,
          sessionTimeoutMinutes: 30,
          enableBiometrics: true,
          enableSSLPinning: false,
          maxOfflineCacheDays: 7,
        );
      case AppEnvironment.staging:
        return AppConfig(
          environment: AppEnvironment.staging,
          apiBaseUrl: 'https://staging-api.yourbank.com/v1',
          appName: 'Your Bank Staging',
          enableLogging: true,
          enableCrashlytics: true,
          enablePerformanceMonitoring: true,
          sessionTimeoutMinutes: 15,
          enableBiometrics: true,
          enableSSLPinning: true,
          maxOfflineCacheDays: 5,
        );
      case AppEnvironment.production:
        return AppConfig(
          environment: AppEnvironment.production,
          apiBaseUrl: 'https://api.yourbank.com/v1',
          appName: 'Your Bank',
          enableLogging: false,
          enableCrashlytics: true,
          enablePerformanceMonitoring: true,
          sessionTimeoutMinutes: 5,
          enableBiometrics: true,
          enableSSLPinning: true,
          maxOfflineCacheDays: 3,
        );
    }
  }

  bool get isDevelopment => environment == AppEnvironment.development;
  bool get isStaging => environment == AppEnvironment.staging;
  bool get isProduction => environment == AppEnvironment.production;
}
