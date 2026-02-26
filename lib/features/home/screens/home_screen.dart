import 'package:baseline_pulse/app/theme/bp_text.dart';
import 'package:baseline_pulse/core/bootstrap/app_bootstrap.dart';
import 'package:baseline_pulse/features/home/widgets/feature_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.container});

  final BootstrapContainer container;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BASELINE PULSE')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text('Train With Precision', style: BpText.title),
          const SizedBox(height: 16),
          FeatureTile(
            title: 'Run',
            subtitle: 'Intervals, tempo, guided setup',
            icon: Icons.directions_run,
            onTap: () => context.go('/run/setup'),
          ),
          FeatureTile(
            title: 'Ruck',
            subtitle: 'Load-aware sessions with selection mode',
            icon: Icons.fitness_center,
            onTap: () => context.go('/ruck/setup'),
          ),
          FeatureTile(
            title: 'Workouts',
            subtitle: 'Programming hooks for future plans',
            icon: Icons.list_alt,
            onTap: () => context.go('/workouts'),
          ),
          FeatureTile(
            title: 'Recovery',
            subtitle: 'Health Connect status + readiness hooks',
            icon: Icons.favorite,
            onTap: () => context.go('/recovery'),
          ),
          const SizedBox(height: 12),
          Text(
            container.firebaseReady
                ? 'Firebase connected (anonymous auth active).'
                : 'Offline mode: Firebase unavailable. Local tracking still active.',
          ),
        ],
      ),
    );
  }
}
