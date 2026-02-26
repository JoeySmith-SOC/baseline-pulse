import 'package:baseline_pulse/features/run/models/run_session.dart';
import 'package:hive/hive.dart';

class RunStorageService {
  RunStorageService(this._box);

  final Box<RunSession> _box;

  Future<void> save(RunSession session) async {
    await _box.put(session.id, session);
  }

  List<RunSession> listNewestFirst() {
    final List<RunSession> items = _box.values.toList();
    items.sort((RunSession a, RunSession b) => b.startedAt.compareTo(a.startedAt));
    return items;
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  RunSession? byId(String id) => _box.get(id);
}
