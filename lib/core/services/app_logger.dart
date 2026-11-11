import 'dart:developer' as developer;

/// A simple structured logger for the application.
abstract final class AppLogger {
  /// Logs a debug message.
  static void debug(String message, {String? tag}) {
    developer.log(
      message,
      name: tag ?? 'DEBUG',
      level: 500,
    );
  }

  /// Logs an informational message.
  static void info(String message, {String? tag}) {
    developer.log(
      message,
      name: tag ?? 'INFO',
      level: 800,
    );
  }

  /// Logs a warning message.
  static void warning(String message, {String? tag}) {
    developer.log(
      message,
      name: tag ?? 'WARN',
      level: 900,
    );
  }

  /// Logs an error message with optional exception and stack trace.
  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    developer.log(
      message,
      name: tag ?? 'ERROR',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
