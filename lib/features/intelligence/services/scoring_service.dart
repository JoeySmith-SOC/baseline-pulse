import 'dart:math' as math;

import 'package:baseline_pulse/core/utils/unit_format.dart';

class ScoringService {
  double scoreRun({
    required double distanceMeters,
    required int durationSeconds,
    required DistanceUnit unit,
  }) {
    final double distanceUnit = UnitFormat.metersToUnit(distanceMeters, unit);
    final double pacePenalty = durationSeconds <= 0 ? 1 : (durationSeconds / 60) / (distanceUnit + 1);
    return math.max(0, (distanceUnit * 12) - (pacePenalty * 3)).clamp(0, 100).toDouble();
  }

  double scoreRuck({
    required double distanceMeters,
    required int durationSeconds,
    required DistanceUnit unit,
    required double weightLbs,
    required bool selectionMode,
  }) {
    final double base = scoreRun(
      distanceMeters: distanceMeters,
      durationSeconds: durationSeconds,
      unit: unit,
    );
    final double loadFactor = (weightLbs / 45).clamp(0.6, 2.0);
    final double selectionMultiplier = selectionMode ? 1.1 : 1;
    return (base * loadFactor * selectionMultiplier).clamp(0, 100).toDouble();
  }
}
