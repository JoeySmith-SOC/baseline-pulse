import 'package:baseline_pulse/core/bootstrap/app_bootstrap.dart';
import 'package:baseline_pulse/features/subscription/models/entitlement_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecoveryScreen extends StatefulWidget {
  const RecoveryScreen({super.key, required this.container});

  final BootstrapContainer container;

  @override
  State<RecoveryScreen> createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends State<RecoveryScreen> {
  bool _connected = false;
  int? _steps;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final bool connected = await widget.container.healthConnectService.isConnected();
    int? steps;
    if (connected) {
      steps = await widget.container.healthConnectService.readTodaySteps();
    }
    if (mounted) {
      setState(() {
        _connected = connected;
        _steps = steps;
      });
    }
  }

  Future<void> _connect() async {
    await widget.container.healthConnectService.requestPermissions();
    await _refresh();
  }

  void _showAdvanced() {
    if (!widget.container.subscriptionService.has(PremiumFeatureFlag.intelligenceAdvanced)) {
      context.push('/paywall');
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Advanced recovery analytics scaffold.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recovery')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(_connected ? 'Health Connect: Connected' : 'Health Connect: Not connected'),
            const SizedBox(height: 8),
            Text('Today Steps: ${_steps ?? '--'}'),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _connect, child: const Text('Connect Health')),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _showAdvanced, child: const Text('Advanced Recovery (Premium)')),
          ],
        ),
      ),
    );
  }
}
