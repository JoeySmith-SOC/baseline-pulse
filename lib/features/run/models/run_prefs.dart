import 'package:baseline_pulse/core/utils/unit_format.dart';

class RunPrefs {
  const RunPrefs({
    required this.autoUnit,
    required this.unitOverride,
  });

  final bool autoUnit;
  final DistanceUnit? unitOverride;
}
