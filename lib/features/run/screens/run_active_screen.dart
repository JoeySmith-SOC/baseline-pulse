import 'dart:async';

import 'package:baseline_pulse/core/bootstrap/app_bootstrap.dart';
import 'package:baseline_pulse/core/utils/date_format.dart';
import 'package:baseline_pulse/core/utils/unit_format.dart';
import 'package:baseline_pulse/features/run/models/run_session.dart';
import 'package:baseline_pulse/features/run/screens/run_summary_screen.dart';
import 'package:baseline_pulse/features/run/services/run_engine.dart';
import 'package:baseline_pulse/features/run/widgets/map_route_view.dart';
import 'package:baseline_pulse/features/run/widgets/pace_display.dart';
import 'package:baseline_pulse/features/run/widgets/split_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class RunActiveArgs {
  const RunActiveArgs({required this.config});

  final RunConfig config;
}

class RunActiveScreen extends StatefulWidget {
  const RunActiveScreen({super.key, required this.container, required this.args});

  final BootstrapContainer container;
  final RunActiveArgs args;

  @override
  State<RunActiveScreen> createState() => _RunActiveScreenState();
}

class _RunActiveScreenState extends State<RunActiveScreen> {
  final RunEngine _engine = RunEngine();
  RunLiveState? _state;
  StreamSubscription<RunLiveState>? _sub;
  DateTime? _startedAt;
  bool _finishing = false;

  @override
  void initState() {
    super.initState();
    _startedAt = DateTime.now();
    _sub = _engine.stream.listen((RunLiveState state) {
      if (_finishing) {
        return;
      }
      if (mounted) {
        setState(() => _state = state);
      }
      if (state.remaining != null && state.remaining!.inSeconds <= 0) {
        unawaited(_finish());
      }
    });
    unawaited(_engine.start(widget.args.config));
  }

  @override
  void dispose() {
    _sub?.cancel();
    _engine.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    if (_finishing) {
      return;
    }
    _finishing = true;
    final RunEngineResult result = await _engine.finish();
    final DateTime started = _startedAt ?? DateTime.now();
    final DateTime ended = DateTime.now();

    final List<RunSession> existingRuns = widget.container.runStorage.listNewestFirst();
    final fatigueRaw = widget.container.fatigueService.rollingFatigue(
      runs: existingRuns,
      rucks: widget.container.ruckStorage.listNewestFirst(),
      days: 7,
    );
    final double score = widget.container.scoringService.scoreRun(
      distanceMeters: result.distanceMeters,
      durationSeconds: result.duration.inSeconds,
      unit: widget.args.config.unit,
    );
    final double readiness = widget.container.fatigueService.readinessFromFatigue(fatigueRaw);

    final RunSession session = RunSession(
      id: const Uuid().v4(),
      startedAt: started,
      endedAt: ended,
      mode: widget.args.config.mode,
      sessionType: widget.args.config.sessionType,
      unit: widget.args.config.unit,
      targetValue: widget.args.config.targetValue,
      durationSeconds: result.duration.inSeconds,
      distanceMeters: result.distanceMeters,
      avgPaceSecondsPerUnit: result.averagePaceSecondsPerUnit,
      gpsEnabled: result.gpsEnabled,
      splits: result.splits,
      routePreview: result.routePreview,
      sessionScore: score,
      fatigueIndex: fatigueRaw,
      readinessScore: readiness,
    );

    await widget.container.runStorage.save(session);
    await widget.container.syncService.syncRun(session);

    if (!mounted) {
      return;
    }
    context.go('/run/summary', extra: RunSummaryArgs(session: session));
  }

  @override
  Widget build(BuildContext context) {
    final RunLiveState? state = _state;
    if (state == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final String timeText = state.remaining != null
        ? DateFormatUtil.duration(state.remaining!)
        : DateFormatUtil.duration(state.elapsed);

    return Scaffold(
      appBar: AppBar(title: const Text('Run Active')),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: MapRouteView(route: state.route)),
          Expanded(
            flex: 5,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                Text(timeText, style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 8),
                Text(UnitFormat.formatDistance(state.distanceMeters, widget.args.config.unit)),
                const SizedBox(height: 8),
                PaceDisplay(
                  currentPace: state.currentPace,
                  avgPace: state.averagePace,
                  unit: widget.args.config.unit,
                ),
                const SizedBox(height: 8),
                Text('Splits: ${state.splits.length}'),
                SplitList(splits: state.splits),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: state.paused ? _engine.resume : _engine.pause,
                        child: Text(state.paused ? 'Resume' : 'Pause'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _finish,
                        child: const Text('Finish'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
