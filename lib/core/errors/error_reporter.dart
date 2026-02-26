import 'package:flutter/foundation.dart';

abstract interface class ErrorReporter {
  void recordFlutterError(FlutterErrorDetails details);
  void recordError(Object error, StackTrace stackTrace, {String? reason});
}
