import 'package:flutter/foundation.dart';

class AppLogger {
  AppLogger._();

  static final AppLogger instance = AppLogger._();

  void info(String message) {
    debugPrint('[INFO] $message');
  }

  void error(String message, Object error, StackTrace? stackTrace) {
    debugPrint('[ERROR] $message | error: $error');
    if (stackTrace != null) {
      debugPrint(stackTrace.toString());
    }
  }
}
