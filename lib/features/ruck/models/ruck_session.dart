import 'package:baseline_pulse/features/run/models/run_session.dart';
import 'package:baseline_pulse/features/run/models/run_split.dart';
import 'package:baseline_pulse/core/utils/unit_format.dart';

class RuckSession {
  const RuckSession({
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
    required this.ruckWeightLbs,
    required this.selectionMode,
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
  final double ruckWeightLbs;
  final bool selectionMode;
  final double sessionScore;
  final double fatigueIndex;
  final double readinessScore;
}
