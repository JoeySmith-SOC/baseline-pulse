import 'package:baseline_pulse/features/run/models/run_session.dart';
import 'package:flutter/material.dart';

class RunModeSelector extends StatelessWidget {
  const RunModeSelector({
    super.key,
    required this.mode,
    required this.onChanged,
  });

  final SessionMode mode;
  final ValueChanged<SessionMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<SessionMode>(
      segments: const <ButtonSegment<SessionMode>>[
        ButtonSegment(value: SessionMode.time, label: Text('Time')),
        ButtonSegment(value: SessionMode.distance, label: Text('Distance')),
        ButtonSegment(value: SessionMode.open, label: Text('Open')),
      ],
      selected: <SessionMode>{mode},
      onSelectionChanged: (Set<SessionMode> selection) {
        onChanged(selection.first);
      },
    );
  }
}
