import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/di/injection.dart';
import 'app/config/environment.dart';
import 'app/config/flavor_config.dart';

Future<void> main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize flavor config for development
  FlavorConfig(
    environment: AppEnvironment.development,
    name: 'Development',
    apiBaseUrl: dotenv.env['API_URL_DEV'] ?? 'https://dev-api.yourbank.com/v1',
  );

  // Initialize dependency injection
  await configureDependencies();

  // Run the app
  //runApp(const BankingApp());
}
