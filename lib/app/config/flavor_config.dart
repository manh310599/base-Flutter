import 'environment.dart';

/// Flavor configuration for different build variants
class FlavorConfig {
  final AppEnvironment environment;
  final String name;
  final String apiBaseUrl;

  static FlavorConfig? _instance;

  factory FlavorConfig({
    required AppEnvironment environment,
    required String name,
    required String apiBaseUrl,
  }) {
    _instance ??= FlavorConfig._internal(
      environment: environment,
      name: name,
      apiBaseUrl: apiBaseUrl,
    );

    return _instance!;
  }

  FlavorConfig._internal({
    required this.environment,
    required this.name,
    required this.apiBaseUrl,
  });

  static FlavorConfig get instance {
    if (_instance == null) {
      throw Exception('FlavorConfig has not been initialized');
    }
    return _instance!;
  }
}
