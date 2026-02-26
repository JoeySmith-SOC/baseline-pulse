import 'dart:ui';

import 'package:baseline_pulse/core/utils/unit_format.dart';
import 'package:baseline_pulse/features/run/models/run_prefs.dart';
import 'package:hive/hive.dart';

class RunPrefsService {
  RunPrefsService(this._box);

  final Box<RunPrefs> _box;
  static const String _key = 'prefs';

  RunPrefs get prefs => _box.get(_key) ?? const RunPrefs(autoUnit: true, unitOverride: null);

  DistanceUnit resolvedUnit() {
    final RunPrefs current = prefs;
    if (!current.autoUnit && current.unitOverride != null) {
      return current.unitOverride!;
    }
    return UnitFormat.localeDefault(
      PlatformDispatcher.instance.locale.toLanguageTag(),
    );
  }

  Future<void> setAutoUnit(bool enabled) async {
    final RunPrefs current = prefs;
    await _box.put(
      _key,
      RunPrefs(autoUnit: enabled, unitOverride: current.unitOverride),
    );
  }

  Future<void> setUnitOverride(DistanceUnit unit) async {
    final RunPrefs current = prefs;
    await _box.put(
      _key,
      RunPrefs(autoUnit: current.autoUnit, unitOverride: unit),
    );
  }
}
