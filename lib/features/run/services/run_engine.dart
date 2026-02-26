import 'dart:async';
import 'dart:math' as math;

import 'package:baseline_pulse/core/utils/geo_math.dart';
import 'package:baseline_pulse/core/utils/pace_math.dart';
import 'package:baseline_pulse/core/utils/unit_format.dart';
import 'package:baseline_pulse/features/run/models/run_session.dart';
import 'package:baseline_pulse/features/run/models/run_split.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RunConfig {
  const RunConfig({
    required this.mode,
    required this.sessionType,
    required this.unit,
    required this.gpsEnabled,
    this.targetValue,
  });

  final SessionMode mode;
  final SessionType sessionType;
  final DistanceUnit unit;
  final bool gpsEnabled;
  final double? targetValue;
}

class RunLiveState {
  const RunLiveState({
    required this.elapsed,
    required this.remaining,
    required this.distanceMeters,
    required this.currentPace,
    required this.averagePace,
    required this.splits,
    required this.route,
    required this.paused,
    required this.gpsEnabled,
  });

  final Duration elapsed;
  final Duration? remaining;
  final double distanceMeters;
  final double? currentPace;
  final double? averagePace;
  final List<RunSplit> splits;
  final List<LatLng> route;
  final bool paused;
  final bool gpsEnabled;
}

class RunEngine {
  RunEngine();

  final StreamController<RunLiveState> _controller =
      StreamController<RunLiveState>.broadcast();
  final Stopwatch _watch = Stopwatch();
  final List<LatLng> _route = <LatLng>[];
  final List<RunSplit> _splits = <RunSplit>[];
  final List<_PaceSample> _paceSamples = <_PaceSample>[];

  Timer? _ticker;
  StreamSubscription<Position>? _gpsSub;
  RunConfig? _config;
  double _distanceMeters = 0;
  LatLng? _lastPoint;
  int _lastSplitIndex = 0;

  Stream<RunLiveState> get stream => _controller.stream;

  Future<void> start(RunConfig config) async {
    _config = config;
    _watch
      ..reset()
      ..start();

    _distanceMeters = 0;
    _route.clear();
    _splits.clear();
    _paceSamples.clear();
    _lastPoint = null;
    _lastSplitIndex = 0;

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _emit());

    if (config.gpsEnabled) {
      _gpsSub = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 7,
        ),
      ).listen(_onPosition);
    }

    _emit();
  }

  void pause() {
    _watch.stop();
    _emit();
  }

  void resume() {
    _watch.start();
    _emit();
  }

  Future<RunEngineResult> finish() async {
    _watch.stop();
    _ticker?.cancel();
    await _gpsSub?.cancel();

    final RunConfig config = _config!;
    final double? avgPace = PaceMath.paceSecondsPerUnit(
      elapsedSeconds: _watch.elapsed.inSeconds,
      meters: _distanceMeters,
      unit: config.unit,
    );

    return RunEngineResult(
      duration: _watch.elapsed,
      distanceMeters: _distanceMeters,
      splits: List<RunSplit>.unmodifiable(_splits),
      routePreview: _sampleRoute(_route),
      averagePaceSecondsPerUnit: avgPace,
      gpsEnabled: config.gpsEnabled,
    );
  }

  void dispose() {
    _ticker?.cancel();
    _gpsSub?.cancel();
    _controller.close();
  }

  void _onPosition(Position pos) {
    if (!_watch.isRunning) {
      return;
    }

    final LatLng point = LatLng(pos.latitude, pos.longitude);
    if (_lastPoint != null) {
      final double delta = GeoMath.haversineMeters(_lastPoint!, point);
      if (delta > 0.5 && delta < 100) {
        _distanceMeters += delta;
      }
    }

    _lastPoint = point;
    _route.add(point);
    _paceSamples.add(_PaceSample(at: DateTime.now(), distanceMeters: _distanceMeters));
    _trimPaceWindow();

    _emit();
  }

  void _trimPaceWindow() {
    final DateTime cutoff = DateTime.now().subtract(const Duration(seconds: 45));
    _paceSamples.removeWhere((item) => item.at.isBefore(cutoff));
  }

  void _emit() {
    final RunConfig? config = _config;
    if (config == null) {
      return;
    }

    final int elapsedSec = _watch.elapsed.inSeconds;
    final double splitLength = UnitFormat.splitLengthMeters(config.unit);
    final int currentSplit = (_distanceMeters / splitLength).floor();

    if (currentSplit > _lastSplitIndex) {
      for (int i = _lastSplitIndex + 1; i <= currentSplit; i++) {
        _splits.add(
          RunSplit(
            index: i,
            elapsedSeconds: elapsedSec,
            splitDistanceMeters: splitLength,
          ),
        );
      }
      _lastSplitIndex = currentSplit;
    }

    final double? averagePace = PaceMath.paceSecondsPerUnit(
      elapsedSeconds: elapsedSec,
      meters: _distanceMeters,
      unit: config.unit,
    );

    final double? currentPace = _currentPace(config.unit);

    Duration? remaining;
    if (config.mode == SessionMode.time && config.targetValue != null) {
      final int targetSec = (config.targetValue! * 60).round();
      remaining = Duration(seconds: math.max(0, targetSec - elapsedSec));
    }

    _controller.add(
      RunLiveState(
        elapsed: _watch.elapsed,
        remaining: remaining,
        distanceMeters: _distanceMeters,
        currentPace: currentPace,
        averagePace: averagePace,
        splits: List<RunSplit>.unmodifiable(_splits),
        route: List<LatLng>.unmodifiable(_route),
        paused: !_watch.isRunning,
        gpsEnabled: config.gpsEnabled,
      ),
    );
  }

  double? _currentPace(DistanceUnit unit) {
    if (_paceSamples.length < 2) {
      return null;
    }

    final _PaceSample first = _paceSamples.first;
    final _PaceSample last = _paceSamples.last;

    final int elapsed = last.at.difference(first.at).inSeconds;
    final double meters = last.distanceMeters - first.distanceMeters;
    if (elapsed <= 0 || meters <= 0) {
      return null;
    }

    return PaceMath.paceSecondsPerUnit(
      elapsedSeconds: elapsed,
      meters: meters,
      unit: unit,
    );
  }

  static List<RoutePoint> _sampleRoute(List<LatLng> points) {
    if (points.isEmpty) {
      return const <RoutePoint>[];
    }

    final List<LatLng> smoothed = GeoMath.smooth(points, window: 4);
    final List<RoutePoint> sampled = <RoutePoint>[];

    for (int i = 0; i < smoothed.length; i += 6) {
      sampled.add(RoutePoint(lat: smoothed[i].latitude, lng: smoothed[i].longitude));
    }
    if (sampled.length > 200) {
      return sampled.sublist(0, 200);
    }
    return sampled;
  }
}

class RunEngineResult {
  const RunEngineResult({
    required this.duration,
    required this.distanceMeters,
    required this.splits,
    required this.routePreview,
    required this.averagePaceSecondsPerUnit,
    required this.gpsEnabled,
  });

  final Duration duration;
  final double distanceMeters;
  final List<RunSplit> splits;
  final List<RoutePoint> routePreview;
  final double? averagePaceSecondsPerUnit;
  final bool gpsEnabled;
}

class _PaceSample {
  const _PaceSample({required this.at, required this.distanceMeters});

  final DateTime at;
  final double distanceMeters;
}
