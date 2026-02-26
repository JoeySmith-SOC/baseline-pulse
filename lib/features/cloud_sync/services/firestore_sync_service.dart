import 'dart:async';

import 'package:baseline_pulse/features/cloud_sync/models/sync_status.dart';
import 'package:baseline_pulse/features/cloud_sync/services/auth_service.dart';
import 'package:baseline_pulse/features/ruck/models/ruck_session.dart';
import 'package:baseline_pulse/features/run/models/run_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

class FirestoreSyncService {
  FirestoreSyncService({
    required this.authService,
    required this.firestore,
    required this.queue,
  });

  final AuthService authService;
  final FirebaseFirestore? firestore;
  final Box<Map> queue;

  bool get available => firestore != null && authService.available;

  Future<void> syncRun(RunSession session) async {
    final Map<String, dynamic> payload = _runPayload(session);
    await _enqueue('run', session.id, payload);
    await flush();
  }

  Future<void> syncRuck(RuckSession session) async {
    final Map<String, dynamic> payload = _ruckPayload(session);
    await _enqueue('ruck', session.id, payload);
    await flush();
  }

  Future<void> flush() async {
    if (!available || authService.user == null) {
      return;
    }

    final String uid = authService.user!.uid;
    final List<String> keys = queue.keys.cast<String>().toList();

    for (final String key in keys) {
      final Map? raw = queue.get(key);
      if (raw == null) {
        continue;
      }
      final Map<String, dynamic> item = Map<String, dynamic>.from(raw);
      final String type = item['type'] as String;
      final String id = item['id'] as String;
      final Map<String, dynamic> data = Map<String, dynamic>.from(item['data'] as Map);

      try {
        final CollectionReference<Map<String, dynamic>> col = firestore!
            .collection('users')
            .doc(uid)
            .collection(type == 'run' ? 'runs' : 'rucks');
        await col.doc(id).set(data, SetOptions(merge: true));
        await queue.delete(key);
      } catch (_) {
        await queue.put(
          key,
          <String, dynamic>{
            ...item,
            'status': SyncStatus.failed.name,
            'attemptedAt': DateTime.now().toIso8601String(),
          },
        );
      }
    }
  }

  Future<void> _enqueue(String type, String id, Map<String, dynamic> data) async {
    await queue.put(
      '$type:$id',
      <String, dynamic>{
        'type': type,
        'id': id,
        'status': SyncStatus.pending.name,
        'createdAt': DateTime.now().toIso8601String(),
        'data': data,
      },
    );
  }

  Map<String, dynamic> _runPayload(RunSession session) {
    return <String, dynamic>{
      'id': session.id,
      'startedAt': session.startedAt.toIso8601String(),
      'endedAt': session.endedAt.toIso8601String(),
      'mode': session.mode.name,
      'sessionType': session.sessionType.name,
      'durationSeconds': session.durationSeconds,
      'distanceMeters': session.distanceMeters,
      'avgPaceSecondsPerUnit': session.avgPaceSecondsPerUnit,
      'gpsEnabled': session.gpsEnabled,
      'splits': session.splits
          .map((s) => {'index': s.index, 'elapsedSeconds': s.elapsedSeconds})
          .toList(),
      'routePreview': session.routePreview
          .map((p) => {'lat': p.lat, 'lng': p.lng})
          .toList(),
    };
  }

  Map<String, dynamic> _ruckPayload(RuckSession session) {
    return <String, dynamic>{
      ..._runPayload(
        RunSession(
          id: session.id,
          startedAt: session.startedAt,
          endedAt: session.endedAt,
          mode: session.mode,
          sessionType: session.sessionType,
          unit: session.unit,
          targetValue: session.targetValue,
          durationSeconds: session.durationSeconds,
          distanceMeters: session.distanceMeters,
          avgPaceSecondsPerUnit: session.avgPaceSecondsPerUnit,
          gpsEnabled: session.gpsEnabled,
          splits: session.splits,
          routePreview: session.routePreview,
          sessionScore: session.sessionScore,
          fatigueIndex: session.fatigueIndex,
          readinessScore: session.readinessScore,
        ),
      ),
      'ruckWeightLbs': session.ruckWeightLbs,
      'selectionMode': session.selectionMode,
    };
  }
}
