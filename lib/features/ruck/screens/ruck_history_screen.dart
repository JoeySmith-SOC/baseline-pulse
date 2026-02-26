import 'package:baseline_pulse/core/bootstrap/app_bootstrap.dart';
import 'package:baseline_pulse/core/utils/date_format.dart';
import 'package:baseline_pulse/core/utils/unit_format.dart';
import 'package:baseline_pulse/features/ruck/models/ruck_session.dart';
import 'package:baseline_pulse/features/ruck/screens/ruck_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RuckHistoryScreen extends StatefulWidget {
  const RuckHistoryScreen({super.key, required this.container});

  final BootstrapContainer container;

  @override
  State<RuckHistoryScreen> createState() => _RuckHistoryScreenState();
}

class _RuckHistoryScreenState extends State<RuckHistoryScreen> {
  late List<RuckSession> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.container.ruckStorage.listNewestFirst();
  }

  Future<void> _delete(String id) async {
    await widget.container.ruckStorage.delete(id);
    setState(() {
      _items = widget.container.ruckStorage.listNewestFirst();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ruck History')),
      body: _items.isEmpty
          ? const Center(child: Text('No rucks yet.'))
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (BuildContext context, int index) {
                final RuckSession ruck = _items[index];
                return ListTile(
                  title: Text(UnitFormat.formatDistance(ruck.distanceMeters, ruck.unit)),
                  subtitle: Text(
                    '${DateFormatUtil.timestamp(ruck.startedAt)} • ${ruck.ruckWeightLbs.toStringAsFixed(1)} lbs',
                  ),
                  onTap: () {
                    context.push('/ruck/summary', extra: RuckSummaryArgs(session: ruck));
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      final bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Delete ruck?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await _delete(ruck.id);
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
