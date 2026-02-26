import 'dart:async';

import 'package:baseline_pulse/core/bootstrap/app_bootstrap.dart';
import 'package:baseline_pulse/core/utils/date_format.dart';
import 'package:baseline_pulse/core/utils/unit_format.dart';
import 'package:baseline_pulse/features/ruck/models/ruck_session.dart';
import 'package:baseline_pulse/features/ruck/screens/ruck_summary_screen.dart';
import 'package:baseline_pulse/features/ruck/services/ruck_engine.dart';
import 'package:baseline_pulse/features/ruck/widgets/selection_mode_badge.dart';
import 'package:baseline_pulse/features/run/models/run_session.dart';
import 'package:baseline_pulse/features/run/services/run_engine.dart';
import 'package:baseline_pulse/features/run/widgets/map_route_view.dart';
import 'package:baseline_pulse/features/run/widgets/pace_display.dart';
import 'package:baseline_pulse/features/run/widgets/split_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class RuckActiveArgs {
  const RuckActiveArgs({required this.config});

  final RuckConfig config;
}

class RuckActiveScreen extends StatefulWidget {
  const RuckActiveScreen({super.key, required this.container, required this.args});

  final BootstrapContainer container;
  final RuckActiveArgs args;

  @override
  State<RuckActiveScreen> createState() => _RuckActiveScreenState();
}

class _RuckActiveScreenState extends State<RuckActiveScreen> {
  late final RuckEngine _engine;
  RunLiveState? _state;
  StreamSubscription<RunLiveState>? _sub;
  DateTime? _startedAt;
  bool _finishing = false;

  @override
  void initState() {
    super.initState();
    _engine = RuckEngine(RunEngine());
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

    final double fatigueRaw = widget.container.fatigueService.rollingFatigue(
      runs: widget.container.runStorage.listNewestFirst(),
      rucks: widget.container.ruckStorage.listNewestFirst(),
      days: 7,
    );

    final double score = widget.container.scoringService.scoreRuck(
      distanceMeters: result.distanceMeters,
      durationSeconds: result.duration.inSeconds,
      unit: widget.args.config.runConfig.unit,
      weightLbs: widget.args.config.weightLbs,
      selectionMode: widget.args.config.selectionMode,
    );

    final RuckSession session = RuckSession(
      id: const Uuid().v4(),
      startedAt: started,
      endedAt: ended,
      mode: widget.args.config.runConfig.mode,
      sessionType: widget.args.config.runConfig.sessionType,
      unit: widget.args.config.runConfig.unit,
      targetValue: widget.args.config.runConfig.targetValue,
      durationSeconds: result.duration.inSeconds,
      distanceMeters: result.distanceMeters,
      avgPaceSecondsPerUnit: result.averagePaceSecondsPerUnit,
      gpsEnabled: result.gpsEnabled,
      splits: result.splits,
      routePreview: result.routePreview,
      ruckWeightLbs: widget.args.config.weightLbs,
      selectionMode: widget.args.config.selectionMode,
      sessionScore: score,
      fatigueIndex: fatigueRaw,
      readinessScore: widget.container.fatigueService.readinessFromFatigue(fatigueRaw),
    );

    await widget.container.ruckStorage.save(session);
    await widget.container.syncService.syncRuck(session);

    if (!mounted) {
      return;
    }
    context.go('/ruck/summary', extra: RuckSummaryArgs(session: session));
  }

  @override
  Widget build(BuildContext context) {
    final RunLiveState? state = _state;
    if (state == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final String timer = state.remaining != null
        ? DateFormatUtil.duration(state.remaining!)
        : DateFormatUtil.duration(state.elapsed);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ruck Active'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8),
            child: SelectionModeBadge(enabled: widget.args.config.selectionMode),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: MapRouteView(route: state.route)),
          Expanded(
            flex: 5,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                Text(timer, style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 8),
                Text(UnitFormat.formatDistance(state.distanceMeters, widget.args.config.runConfig.unit)),
                Text('Load: ${widget.args.config.weightLbs.toStringAsFixed(1)} lbs'),
                PaceDisplay(
                  currentPace: state.currentPace,
                  avgPace: state.averagePace,
                  unit: widget.args.config.runConfig.unit,
                ),
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
