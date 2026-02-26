import 'package:flutter/material.dart';

class SelectionModeBadge extends StatelessWidget {
  const SelectionModeBadge({super.key, required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: enabled ? const Color(0xFFE5252A) : Colors.white24,
      ),
      child: Text(enabled ? 'Selection Mode' : 'Standard Mode'),
    );
  }
}
