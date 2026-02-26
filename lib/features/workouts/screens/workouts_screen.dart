import 'package:flutter/material.dart';

class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workouts')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Coming soon: periodized templates and progression logic hooks.'),
      ),
    );
  }
}
