import 'package:baseline_pulse/core/bootstrap/app_bootstrap.dart';
import 'package:baseline_pulse/core/utils/date_format.dart';
import 'package:baseline_pulse/core/utils/unit_format.dart';
import 'package:baseline_pulse/features/run/models/run_session.dart';
import 'package:baseline_pulse/features/run/screens/run_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RunHistoryScreen extends StatefulWidget {
  const RunHistoryScreen({super.key, required this.container});

  final BootstrapContainer container;

  @override
  State<RunHistoryScreen> createState() => _RunHistoryScreenState();
}

class _RunHistoryScreenState extends State<RunHistoryScreen> {
  late List<RunSession> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.container.runStorage.listNewestFirst();
  }

  Future<void> _delete(String id) async {
    await widget.container.runStorage.delete(id);
    setState(() {
      _items = widget.container.runStorage.listNewestFirst();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Run History')),
      body: _items.isEmpty
          ? const Center(child: Text('No runs yet.'))
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (BuildContext context, int index) {
                final RunSession run = _items[index];
                return ListTile(
                  title: Text(UnitFormat.formatDistance(run.distanceMeters, run.unit)),
                  subtitle: Text(DateFormatUtil.timestamp(run.startedAt)),
                  onTap: () {
                    context.push('/run/summary', extra: RunSummaryArgs(session: run));
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      final bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Delete run?'),
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
                        await _delete(run.id);
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
