import 'package:baseline_pulse/core/bootstrap/app_bootstrap.dart';
import 'package:baseline_pulse/core/utils/unit_format.dart';
import 'package:baseline_pulse/features/ruck/screens/ruck_active_screen.dart';
import 'package:baseline_pulse/features/ruck/services/ruck_engine.dart';
import 'package:baseline_pulse/features/ruck/widgets/ruck_weight_picker.dart';
import 'package:baseline_pulse/features/run/models/run_session.dart';
import 'package:baseline_pulse/features/run/services/run_engine.dart';
import 'package:baseline_pulse/features/run/widgets/run_mode_selector.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

class RuckSetupScreen extends StatefulWidget {
  const RuckSetupScreen({super.key, required this.container});

  final BootstrapContainer container;

  @override
  State<RuckSetupScreen> createState() => _RuckSetupScreenState();
}

class _RuckSetupScreenState extends State<RuckSetupScreen> {
  final TextEditingController _targetController = TextEditingController();
  late final TextEditingController _weightController;
  SessionMode _mode = SessionMode.open;
  SessionType _type = SessionType.tempo;
  bool _selectionMode = false;
  late DistanceUnit _unit;

  @override
  void initState() {
    super.initState();
    _unit = widget.container.runPrefs.resolvedUnit();
    final double initialWeight = widget.container.ruckStorage.lastWeight() ??
        RuckEngine.defaultWeight(male: true);
    _weightController = TextEditingController(text: initialWeight.toStringAsFixed(1));
  }

  @override
  void dispose() {
    _targetController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    final double? weight = double.tryParse(_weightController.text.trim());
    if (weight == null || !RuckEngine.validWeight(weight)) {
      _toast('Enter valid weight (10-200 lbs).');
      return;
    }

    final double? target = double.tryParse(_targetController.text.trim());
    if ((_mode == SessionMode.time || _mode == SessionMode.distance) && target == null) {
      _toast('Enter a valid target value first.');
      return;
    }

    final LocationPermission permission =
        await widget.container.permissionsService.requestLocation();
    final bool hasGps = widget.container.permissionsService.hasGps(permission);

    bool proceed = true;
    if (!hasGps && _mode != SessionMode.time) {
      proceed = await _confirmNoGps();
    }
    if (!proceed) {
      return;
    }

    final RuckActiveArgs args = RuckActiveArgs(
      config: RuckConfig(
        runConfig: RunConfig(
          mode: _mode,
          sessionType: _type,
          unit: _unit,
          gpsEnabled: hasGps,
          targetValue: target,
        ),
        weightLbs: weight,
        selectionMode: _selectionMode,
      ),
    );

    if (!mounted) {
      return;
    }
    context.push('/ruck/active', extra: args);
  }

  Future<bool> _confirmNoGps() async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('GPS unavailable'),
        content: const Text('Start without GPS? Distance and pace unavailable.'),
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
      ),
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
        title: const Text('Ruck Setup'),
        actions: <Widget>[
          TextButton(
            onPressed: () => context.push('/ruck/history'),
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
            items: SessionType.values
                .map((SessionType type) => DropdownMenuItem(
                      value: type,
                      child: Text(type.name.toUpperCase()),
                    ))
                .toList(),
            onChanged: (SessionType? value) {
              if (value != null) {
                setState(() => _type = value);
              }
            },
            decoration: const InputDecoration(labelText: 'Ruck Type'),
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
          RuckWeightPicker(controller: _weightController),
          SwitchListTile(
            value: _selectionMode,
            onChanged: (bool value) => setState(() => _selectionMode = value),
            title: const Text('Selection Mode'),
          ),
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
          ElevatedButton(onPressed: _start, child: const Text('Start Ruck')),
        ],
      ),
    );
  }
}
