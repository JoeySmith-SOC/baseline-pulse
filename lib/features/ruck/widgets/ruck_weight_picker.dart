import 'package:flutter/material.dart';

class RuckWeightPicker extends StatelessWidget {
  const RuckWeightPicker({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        labelText: 'Ruck Weight (lbs)',
        helperText: 'Default: Male 45 / Female 35',
      ),
    );
  }
}
