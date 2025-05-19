import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

/// Custom log printer that includes the caller info.
class CustomLogPrinter extends LogPrinter {
  final String className;
  final bool printCallerInfo;

  CustomLogPrinter({
    required this.className,
    this.printCallerInfo = true,
  });

  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter.levelColors[event.level];
    final emoji = PrettyPrinter.levelEmojis[event.level];
    final message = event.message;

    final callerInfo = printCallerInfo ? ' | $className' : '';
    return [color!('$emoji $message$callerInfo')];
  }
}

/// Log filter that only allows logs in debug mode.
class DebugLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return kDebugMode;
  }
}

/// Log filter that allows logs in all modes.
class ReleaseLogFilter extends LogFilter {
  final Level level;

  ReleaseLogFilter({this.level = Level.warning});

  @override
  bool shouldLog(LogEvent event) {
    return event.level.index >= level.index;
  }
}

/// Factory for creating loggers.
@singleton
class AppLoggerFactory {
  /// Creates a logger with the given class name.
  Logger createLogger(String className) {
    return Logger(
      filter: kDebugMode ? DebugLogFilter() : ReleaseLogFilter(),
      printer: CustomLogPrinter(className: className),
      output: ConsoleOutput(),
    );
  }
}

/// Base class for classes that need logging.
mixin Loggable {
  late final Logger logger;

  /// Initializes the logger with the class name.
  @mustCallSuper
  void initLogger(AppLoggerFactory loggerFactory) {
    logger = loggerFactory.createLogger(runtimeType.toString());
  }
}

/// Extension methods for Logger.
extension LoggerExtension on Logger {
  /// Logs a network request.
  void logRequest(String method, String url, {Map<String, dynamic>? headers, dynamic body}) {
    i('REQUEST: $method $url');
    if (headers != null) {
      d('Headers: $headers');
    }
    if (body != null) {
      d('Body: $body');
    }
  }

  /// Logs a network response.
  void logResponse(String method, String url, int statusCode, {dynamic body}) {
    i('RESPONSE: $method $url | Status: $statusCode');
    if (body != null) {
      d('Body: $body');
    }
  }

  /// Logs a network error.
  void logNetworkError(String method, String url, dynamic error, {StackTrace? stackTrace}) {
    e('NETWORK ERROR: $method $url', stackTrace);
  }

  /// Logs a database operation.
  void logDatabase(String operation, String table, {dynamic data}) {
    i('DATABASE: $operation on $table');
    if (data != null) {
      d('Data: $data');
    }
  }

  /// Logs a database error.
  void logDatabaseError(String operation, String table, dynamic error, {StackTrace? stackTrace}) {
    e('DATABASE ERROR: $operation on $table', error,  stackTrace);
  }

  /// Logs a navigation event.
  void logNavigation(String from, String to, {Map<String, dynamic>? arguments}) {
    i('NAVIGATION: $from -> $to');
    if (arguments != null) {
      d('Arguments: $arguments');
    }
  }

  /// Logs a user action.
  void logUserAction(String action, {Map<String, dynamic>? data}) {
    i('USER ACTION: $action');
    if (data != null) {
      d('Data: $data');
    }
  }

  /// Logs an authentication event.
  void logAuth(String event, {String? userId}) {
    i('AUTH: $event${userId != null ? ' | User: $userId' : ''}');
  }
}
