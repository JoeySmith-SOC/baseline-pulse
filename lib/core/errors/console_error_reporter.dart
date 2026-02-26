import 'package:baseline_pulse/core/errors/error_reporter.dart';
import 'package:flutter/foundation.dart';

class ConsoleErrorReporter implements ErrorReporter {
  @override
  void recordFlutterError(FlutterErrorDetails details) {
    if (!kReleaseMode) {
      debugPrint('[flutter_error] ${details.exceptionAsString()}');
      final StackTrace? stack = details.stack;
      if (stack != null) {
        debugPrint(stack.toString());
      }
    }
  }

  @override
  void recordError(Object error, StackTrace stackTrace, {String? reason}) {
    if (!kReleaseMode) {
      final String prefix = reason == null ? '' : '[$reason] ';
      debugPrint('[error] $prefix$error');
      debugPrint(stackTrace.toString());
    }
  }
}
