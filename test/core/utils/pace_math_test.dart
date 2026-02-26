import 'package:baseline_pulse/core/utils/pace_math.dart';
import 'package:baseline_pulse/core/utils/unit_format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('pace is null with zero distance', () {
    final double? pace = PaceMath.paceSecondsPerUnit(
      elapsedSeconds: 100,
      meters: 0,
      unit: DistanceUnit.miles,
    );
    expect(pace, isNull);
  });

  test('pace formats as mm:ss', () {
    expect(PaceMath.formatPace(305), '5:05');
  });
}
