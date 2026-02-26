import 'package:baseline_pulse/core/bootstrap/app_bootstrap.dart';
import 'package:baseline_pulse/core/utils/unit_format.dart';
import 'package:baseline_pulse/features/run/models/run_session.dart';
import 'package:baseline_pulse/features/run/screens/run_active_screen.dart';
import 'package:baseline_pulse/features/run/widgets/run_mode_selector.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

class RunSetupScreen extends StatefulWidget {
  const RunSetupScreen({super.key, required this.container});

  final BootstrapContainer container;

  @override
  State<RunSetupScreen> createState() => _RunSetupScreenState();
}

class _RunSetupScreenState extends State<RunSetupScreen> {
  SessionMode _mode = SessionMode.open;
  SessionType _type = SessionType.tempo;
  final TextEditingController _targetController = TextEditingController();
  late DistanceUnit _unit;

  @override
  void initState() {
    super.initState();
    _unit = widget.container.runPrefs.resolvedUnit();
  }

  @override
  void dispose() {
    _targetController.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    final double? target = double.tryParse(_targetController.text.trim());
    if ((_mode == SessionMode.time || _mode == SessionMode.distance) && target == null) {
      _toast('Enter a valid target value first.');
      return;
    }

    final LocationPermission permission =
        await widget.container.permissionsService.requestLocation();
    final bool hasGps = widget.container.permissionsService.hasGps(permission);

    if (!hasGps && _mode != SessionMode.time) {
      final bool proceed = await _confirmNoGps();
      if (!proceed) {
        return;
      }
    }

    final RunActiveArgs args = RunActiveArgs(
      config: RunConfig(
        mode: _mode,
        sessionType: _type,
        unit: _unit,
        gpsEnabled: hasGps,
        targetValue: target,
      ),
    );

    if (!mounted) {
      return;
    }
    context.push('/run/active', extra: args);
  }

  Future<bool> _confirmNoGps() async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('GPS unavailable'),
          content: const Text(
            'Start without GPS? Distance and pace will be unavailable.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Start without GPS'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  Future<void> _setUnit(DistanceUnit unit) async {
    setState(() => _unit = unit);
    await widget.container.runPrefs.setAutoUnit(false);
    await widget.container.runPrefs.setUnitOverride(unit);
  }

  void _toast(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Run Setup'),
        actions: <Widget>[
          TextButton(
            onPressed: () => context.push('/run/history'),
            child: const Text('History'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          RunModeSelector(mode: _mode, onChanged: (SessionMode mode) => setState(() => _mode = mode)),
          const SizedBox(height: 14),
          DropdownButtonFormField<SessionType>(
            value: _type,
            onChanged: (SessionType? value) {
              if (value != null) {
                setState(() => _type = value);
              }
            },
            items: SessionType.values
                .map((SessionType type) => DropdownMenuItem(
                      value: type,
                      child: Text(type.name.toUpperCase()),
                    ))
                .toList(),
            decoration: const InputDecoration(labelText: 'Run Type'),
          ),
          const SizedBox(height: 14),
          if (_mode != SessionMode.open)
            TextField(
              controller: _targetController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: _mode == SessionMode.time
                    ? 'Target Minutes'
                    : 'Target Distance (${UnitFormat.unitLabel(_unit)})',
              ),
            ),
          const SizedBox(height: 14),
          SegmentedButton<DistanceUnit>(
            segments: const <ButtonSegment<DistanceUnit>>[
              ButtonSegment(value: DistanceUnit.miles, label: Text('Miles')),
              ButtonSegment(value: DistanceUnit.kilometers, label: Text('Kilometers')),
            ],
            selected: <DistanceUnit>{_unit},
            onSelectionChanged: (Set<DistanceUnit> selected) {
              _setUnit(selected.first);
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _start, child: const Text('Start Run')),
        ],
      ),
    );
  }
}
