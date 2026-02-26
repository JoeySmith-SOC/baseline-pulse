import 'dart:async';
import 'dart:ui';

import 'package:baseline_pulse/app/baseline_pulse_app.dart';
import 'package:baseline_pulse/core/bootstrap/app_bootstrap.dart';
import 'package:baseline_pulse/core/errors/console_error_reporter.dart';
import 'package:baseline_pulse/core/errors/error_reporter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ErrorReporter reporter = ConsoleErrorReporter();
  FlutterError.onError = (FlutterErrorDetails details) {
    reporter.recordFlutterError(details);
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stackTrace) {
    reporter.recordError(error, stackTrace, reason: 'PlatformDispatcher error');
    return true;
  };

  await runZonedGuarded<Future<void>>(
    () async {
      final BootstrapContainer container = await AppBootstrap(
        reporter: reporter,
      ).initialize();

      runApp(BaselinePulseApp(container: container));
    },
    (Object error, StackTrace stackTrace) {
      reporter.recordError(error, stackTrace, reason: 'runZonedGuarded uncaught');
      if (kDebugMode) {
        debugPrint('Bootstrap failed: $error');
      }
    },
  );
}
