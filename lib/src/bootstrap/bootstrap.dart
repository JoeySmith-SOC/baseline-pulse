import 'dart:async';

import 'package:baseline_pulse/src/app/app.dart';
import 'package:baseline_pulse/src/core/logging/logger.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    AppLogger.instance.error(
      'Flutter framework error',
      details.exception,
      details.stack,
    );
    FlutterError.presentError(details);
  };

  await runZonedGuarded<Future<void>>(
    () async {
      AppLogger.instance.info('Bootstrap start');
      await initHive();
      await initFirebase();
      runApp(const App());
    },
    (error, stackTrace) {
      AppLogger.instance.error('Uncaught zone error', error, stackTrace);
    },
  );
}

Future<void> initHive() async {
  await Hive.initFlutter();
  AppLogger.instance.info('Hive initialized');
}

Future<void> initFirebase() async {
  AppLogger.instance.info('Firebase init placeholder');
}
