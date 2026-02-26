import 'package:baseline_pulse/features/ruck/models/ruck_session.dart';
import 'package:baseline_pulse/features/run/models/run_session.dart';

class FatigueService {
  double rollingFatigue({
    required List<RunSession> runs,
    required List<RuckSession> rucks,
    required int days,
  }) {
    final DateTime cutoff = DateTime.now().subtract(Duration(days: days));
    double load = 0;

    for (final RunSession run in runs.where((s) => s.startedAt.isAfter(cutoff))) {
      load += (run.distanceMeters / 1000) + (run.durationSeconds / 600);
    }

    for (final RuckSession ruck in rucks.where((s) => s.startedAt.isAfter(cutoff))) {
      load += ((ruck.distanceMeters / 1000) * (ruck.ruckWeightLbs / 45)) +
          (ruck.durationSeconds / 500);
    }

    return load;
  }

  double readinessFromFatigue(double fatigue) {
    final double normalized = (fatigue / 25).clamp(0, 1);
    return (100 - (normalized * 100)).clamp(0, 100).toDouble();
  }
}
