import 'package:baseline_pulse/core/utils/pace_math.dart';
import 'package:baseline_pulse/core/utils/unit_format.dart';
import 'package:flutter/material.dart';

class PaceDisplay extends StatelessWidget {
  const PaceDisplay({
    super.key,
    required this.currentPace,
    required this.avgPace,
    required this.unit,
  });

  final double? currentPace;
  final double? avgPace;
  final DistanceUnit unit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Current ${PaceMath.formatPace(currentPace)} /${UnitFormat.unitLabel(unit)}'),
        Text('Avg ${PaceMath.formatPace(avgPace)} /${UnitFormat.unitLabel(unit)}'),
      ],
    );
  }
}
