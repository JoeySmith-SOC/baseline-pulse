import 'package:baseline_pulse/core/utils/date_format.dart';
import 'package:baseline_pulse/core/utils/pace_math.dart';
import 'package:baseline_pulse/core/utils/unit_format.dart';
import 'package:baseline_pulse/features/run/models/run_session.dart';
import 'package:baseline_pulse/features/run/widgets/split_list.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class RunSummaryArgs {
  const RunSummaryArgs({required this.session});

  final RunSession session;
}

class RunSummaryScreen extends StatelessWidget {
  const RunSummaryScreen({super.key, required this.args});

  final RunSummaryArgs args;

  @override
  Widget build(BuildContext context) {
    final RunSession session = args.session;
    return Scaffold(
      appBar: AppBar(title: const Text('Run Summary')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Duration: ${DateFormatUtil.duration(Duration(seconds: session.durationSeconds))}'),
                  Text('Distance: ${UnitFormat.formatDistance(session.distanceMeters, session.unit)}'),
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
          const SizedBox(height: 8),
          SplitList(splits: session.splits),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              SharePlus.instance.share(
                ShareParams(
                  text: 'Run: ${UnitFormat.formatDistance(session.distanceMeters, session.unit)} in '
                      '${DateFormatUtil.duration(Duration(seconds: session.durationSeconds))}',
                ),
              );
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }
}
