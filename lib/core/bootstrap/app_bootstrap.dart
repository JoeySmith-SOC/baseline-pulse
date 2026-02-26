import 'package:baseline_pulse/core/errors/error_reporter.dart';
import 'package:baseline_pulse/data/hive_adapters.dart';
import 'package:baseline_pulse/features/cloud_sync/services/auth_service.dart';
import 'package:baseline_pulse/features/cloud_sync/services/firestore_sync_service.dart';
import 'package:baseline_pulse/features/intelligence/services/fatigue_service.dart';
import 'package:baseline_pulse/features/intelligence/services/scoring_service.dart';
import 'package:baseline_pulse/features/ruck/models/ruck_session.dart';
import 'package:baseline_pulse/features/ruck/services/ruck_storage_service.dart';
import 'package:baseline_pulse/features/run/models/run_prefs.dart';
import 'package:baseline_pulse/features/run/models/run_session.dart';
import 'package:baseline_pulse/features/run/services/run_prefs_service.dart';
import 'package:baseline_pulse/features/run/services/run_storage_service.dart';
import 'package:baseline_pulse/features/subscription/services/subscription_service.dart';
import 'package:baseline_pulse/firebase_options.dart';
import 'package:baseline_pulse/services/health_connect_service.dart';
import 'package:baseline_pulse/services/permissions_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BootstrapContainer {
  BootstrapContainer({
    required this.runStorage,
    required this.ruckStorage,
    required this.runPrefs,
    required this.scoringService,
    required this.fatigueService,
    required this.subscriptionService,
    required this.permissionsService,
    required this.syncService,
    required this.healthConnectService,
    required this.firebaseReady,
  });

  final RunStorageService runStorage;
  final RuckStorageService ruckStorage;
  final RunPrefsService runPrefs;
  final ScoringService scoringService;
  final FatigueService fatigueService;
  final SubscriptionService subscriptionService;
  final PermissionsService permissionsService;
  final FirestoreSyncService syncService;
  final HealthConnectService healthConnectService;
  final bool firebaseReady;
}

class AppBootstrap {
  AppBootstrap({required this.reporter});

  final ErrorReporter reporter;

  Future<BootstrapContainer> initialize() async {
    await _initializeFirebase();
    final FirebaseAuth? auth = Firebase.apps.isNotEmpty ? FirebaseAuth.instance : null;
    final FirebaseFirestore? db = Firebase.apps.isNotEmpty ? FirebaseFirestore.instance : null;

    final AuthService authService = AuthService(auth);
    if (authService.available) {
      try {
        await authService.ensureAnonymousSignIn();
      } catch (error, stackTrace) {
        reporter.recordError(error, stackTrace, reason: 'Anonymous sign in failed');
      }
    }

    await Hive.initFlutter();
    registerHiveAdapters();

    final Box<RunSession> runBox =
        await Hive.openBox<RunSession>('run_sessions_v1');
    final Box<RuckSession> ruckBox =
        await Hive.openBox<RuckSession>('ruck_sessions_v1');
    final Box<RunPrefs> runPrefsBox =
        await Hive.openBox<RunPrefs>('run_prefs_v1');
    final Box<dynamic> ruckPrefsBox = await Hive.openBox<dynamic>('ruck_prefs_v1');
    final Box<Map> syncQueue = await Hive.openBox<Map>('sync_queue_v1');

    final RunStorageService runStorage = RunStorageService(runBox);
    final RuckStorageService ruckStorage = RuckStorageService(ruckBox, ruckPrefsBox);
    final RunPrefsService runPrefs = RunPrefsService(runPrefsBox);
    final SubscriptionService subscription = SubscriptionService(mockMode: true);
    await subscription.initialize();
    await subscription.refresh();

    final FirestoreSyncService syncService = FirestoreSyncService(
      authService: authService,
      firestore: db,
      queue: syncQueue,
    );
    await syncService.flush();

    return BootstrapContainer(
      runStorage: runStorage,
      ruckStorage: ruckStorage,
      runPrefs: runPrefs,
      scoringService: ScoringService(),
      fatigueService: FatigueService(),
      subscriptionService: subscription,
      permissionsService: PermissionsService(),
      syncService: syncService,
      healthConnectService: HealthConnectService(),
      firebaseReady: Firebase.apps.isNotEmpty,
    );
  }

  Future<void> _initializeFirebase() async {
    if (Firebase.apps.isNotEmpty) {
      return;
    }

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (error, stackTrace) {
      reporter.recordError(error, stackTrace, reason: 'Firebase initialize failed');
      if (kDebugMode) {
        debugPrint('Continuing without Firebase.');
      }
    }
  }
}
