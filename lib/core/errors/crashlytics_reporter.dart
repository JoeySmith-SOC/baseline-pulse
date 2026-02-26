import 'package:baseline_pulse/core/errors/error_reporter.dart';
import 'package:flutter/foundation.dart';

class CrashlyticsReporter implements ErrorReporter {
  @override
  void recordFlutterError(FlutterErrorDetails details) {
    if (!kReleaseMode) {
      debugPrint('CrashlyticsReporter stub: ${details.exceptionAsString()}');
    }
    // Future: forward to Firebase Crashlytics.
  }

  @override
  void recordError(Object error, StackTrace stackTrace, {String? reason}) {
    if (!kReleaseMode) {
      debugPrint('CrashlyticsReporter stub: $reason $error');
    }
    // Future: forward to Firebase Crashlytics.
  }
}
