import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Service for logging crashes and errors.
@singleton
class CrashLoggerService {
  final FirebaseCrashlytics _crashlytics;
  final Logger _logger;
  final bool useSentry;
  final String? sentryDsn;

  CrashLoggerService(
    this._crashlytics,
    this._logger, {
    @Named('useSentry') this.useSentry = false,
    @Named('sentryDsn') this.sentryDsn,
  });

  /// Initializes the crash logger service.
  @PostConstruct()
  Future<void> init() async {
    // Set up Crashlytics
    await _crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);
    
    // Set up error handling
    FlutterError.onError = (FlutterErrorDetails details) {
      if (kDebugMode) {
        // In development mode, print the error
        FlutterError.dumpErrorToConsole(details);
      } else {
        // In production mode, report the error
        _crashlytics.recordFlutterError(details);
        if (useSentry && sentryDsn != null) {
          Sentry.captureException(
            details.exception,
            stackTrace: details.stack,
          );
        }
      }
    };

    // Set up Sentry if enabled
    if (useSentry && sentryDsn != null) {
      await SentryFlutter.init(
        (options) {
          options.dsn = sentryDsn;
          options.tracesSampleRate = 1.0;
          options.enableAutoSessionTracking = true;
        },
      );
    }

    _logger.i('Crash logger initialized');
  }

  /// Logs an error with a stack trace.
  Future<void> logError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    Map<String, dynamic>? information,
  }) async {
    _logger.e('Error: $exception', exception, stackTrace);

    if (kDebugMode) {
      return;
    }

    // Log to Crashlytics
    await _crashlytics.recordError(
      exception,
      stackTrace,
      reason: reason,
      information: information!.entries.map((e) => '${e.key}: ${e.value}').toList(),
    );

    // Log to Sentry if enabled
    if (useSentry && sentryDsn != null) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
 
      );
    }
  }

  /// Sets a custom key-value pair for crash reports.
  Future<void> setCustomKey(String key, dynamic value) async {
    await _crashlytics.setCustomKey(key, value.toString());
    
    if (useSentry && sentryDsn != null) {
      Sentry.configureScope((scope) {
        scope.setTag(key, value.toString());
      });
    }
  }

  /// Sets the user identifier for crash reports.
  Future<void> setUserId(String userId) async {
    await _crashlytics.setUserIdentifier(userId);
    
    if (useSentry && sentryDsn != null) {
      Sentry.configureScope((scope) {
        scope.setUser(SentryUser(id: userId));
      });
    }
  }

  /// Logs a message.
  Future<void> log(String message) async {
    _logger.i(message);
    await _crashlytics.log(message);
    
    if (useSentry && sentryDsn != null) {
      Sentry.addBreadcrumb(Breadcrumb(
        message: message,
        level: SentryLevel.info,
      ));
    }
  }

  /// Forces a crash for testing purposes.
  Future<void> forceCrash() async {
    _crashlytics.crash();
  }
}
