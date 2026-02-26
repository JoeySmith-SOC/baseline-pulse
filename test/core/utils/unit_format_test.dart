import 'package:baseline_pulse/core/utils/unit_format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('locale default is miles for US locale', () {
    expect(UnitFormat.localeDefault('en-US'), DistanceUnit.miles);
  });

  test('meters to kilometers conversion', () {
    expect(UnitFormat.metersToUnit(1000, DistanceUnit.kilometers), 1);
  });
}
