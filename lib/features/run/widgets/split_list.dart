import 'package:baseline_pulse/core/utils/date_format.dart';
import 'package:baseline_pulse/features/run/models/run_split.dart';
import 'package:flutter/material.dart';

class SplitList extends StatelessWidget {
  const SplitList({super.key, required this.splits});

  final List<RunSplit> splits;

  @override
  Widget build(BuildContext context) {
    if (splits.isEmpty) {
      return const Text('No splits yet');
    }

    return Column(
      children: splits
          .map(
            (RunSplit split) => ListTile(
              dense: true,
              title: Text('Split ${split.index}'),
              trailing: Text(
                DateFormatUtil.duration(Duration(seconds: split.elapsedSeconds)),
              ),
            ),
          )
          .toList(),
    );
  }
}
