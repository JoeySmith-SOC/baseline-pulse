import 'package:baseline_pulse/features/ruck/models/ruck_session.dart';
import 'package:baseline_pulse/features/run/services/run_engine.dart';

class RuckConfig {
  const RuckConfig({
    required this.runConfig,
    required this.weightLbs,
    required this.selectionMode,
  });

  final RunConfig runConfig;
  final double weightLbs;
  final bool selectionMode;
}

class RuckEngine {
  RuckEngine(this._runEngine);

  final RunEngine _runEngine;

  Stream<RunLiveState> get stream => _runEngine.stream;

  Future<void> start(RuckConfig config) => _runEngine.start(config.runConfig);
  void pause() => _runEngine.pause();
  void resume() => _runEngine.resume();
  Future<RunEngineResult> finish() => _runEngine.finish();
  void dispose() => _runEngine.dispose();

  static bool validWeight(double value) => value >= 10 && value <= 200;

  static double defaultWeight({required bool male}) => male ? 45 : 35;
}
