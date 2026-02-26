import 'package:baseline_pulse/core/utils/date_format.dart';
import 'package:baseline_pulse/core/utils/pace_math.dart';
import 'package:baseline_pulse/core/utils/unit_format.dart';
import 'package:baseline_pulse/features/ruck/models/ruck_session.dart';
import 'package:baseline_pulse/features/ruck/widgets/selection_mode_badge.dart';
import 'package:baseline_pulse/features/ruck/widgets/share_card.dart';
import 'package:baseline_pulse/features/run/widgets/split_list.dart';
import 'package:flutter/material.dart';

class RuckSummaryArgs {
  const RuckSummaryArgs({required this.session});

  final RuckSession session;
}

class RuckSummaryScreen extends StatelessWidget {
  const RuckSummaryScreen({super.key, required this.args});

  final RuckSummaryArgs args;

  @override
  Widget build(BuildContext context) {
    final RuckSession session = args.session;

    return Scaffold(
      appBar: AppBar(title: const Text('Ruck Summary')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          SelectionModeBadge(enabled: session.selectionMode),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Duration: ${DateFormatUtil.duration(Duration(seconds: session.durationSeconds))}'),
                  Text('Distance: ${UnitFormat.formatDistance(session.distanceMeters, session.unit)}'),
                  Text('Load: ${session.ruckWeightLbs.toStringAsFixed(1)} lbs'),
                  Text('Avg Pace: ${PaceMath.formatPace(session.avgPaceSecondsPerUnit)} /${UnitFormat.unitLabel(session.unit)}'),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('Intelligence'),
                  Text('Session Score: ${session.sessionScore.toStringAsFixed(1)}'),
                  Text('Fatigue Index: ${session.fatigueIndex.toStringAsFixed(1)}'),
                  Text('Readiness: ${session.readinessScore.toStringAsFixed(1)}'),
                ],
              ),
            ),
          ),
          SplitList(splits: session.splits),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => RuckShareCard().share(session),
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }
}
