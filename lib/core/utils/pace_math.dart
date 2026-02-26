import 'package:baseline_pulse/core/utils/unit_format.dart';

abstract final class PaceMath {
  static double? paceSecondsPerUnit({
    required int elapsedSeconds,
    required double meters,
    required DistanceUnit unit,
  }) {
    if (elapsedSeconds <= 0 || meters <= 0) {
      return null;
    }
    final double distanceInUnit = UnitFormat.metersToUnit(meters, unit);
    if (distanceInUnit <= 0) {
      return null;
    }
    return elapsedSeconds / distanceInUnit;
  }

  static String formatPace(double? secondsPerUnit) {
    if (secondsPerUnit == null || secondsPerUnit.isNaN || secondsPerUnit.isInfinite) {
      return '--:--';
    }
    final int total = secondsPerUnit.round();
    final int min = total ~/ 60;
    final int sec = total % 60;
    return '$min:${sec.toString().padLeft(2, '0')}';
  }
}
