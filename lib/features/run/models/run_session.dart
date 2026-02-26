import 'package:baseline_pulse/core/utils/unit_format.dart';
import 'package:baseline_pulse/features/run/models/run_split.dart';

enum SessionMode { time, distance, open }

enum SessionType { intervals, tempo, guided }

class RoutePoint {
  const RoutePoint({required this.lat, required this.lng});

  final double lat;
  final double lng;
}

class RunSession {
  const RunSession({
    required this.id,
    required this.startedAt,
    required this.endedAt,
    required this.mode,
    required this.sessionType,
    required this.unit,
    required this.targetValue,
    required this.durationSeconds,
    required this.distanceMeters,
    required this.avgPaceSecondsPerUnit,
    required this.gpsEnabled,
    required this.splits,
    required this.routePreview,
    required this.sessionScore,
    required this.fatigueIndex,
    required this.readinessScore,
  });

  final String id;
  final DateTime startedAt;
  final DateTime endedAt;
  final SessionMode mode;
  final SessionType sessionType;
  final DistanceUnit unit;
  final double? targetValue;
  final int durationSeconds;
  final double distanceMeters;
  final double? avgPaceSecondsPerUnit;
  final bool gpsEnabled;
  final List<RunSplit> splits;
  final List<RoutePoint> routePreview;
  final double sessionScore;
  final double fatigueIndex;
  final double readinessScore;
}
