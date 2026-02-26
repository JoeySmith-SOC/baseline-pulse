import 'package:baseline_pulse/features/ruck/models/ruck_session.dart';
import 'package:hive/hive.dart';

class RuckStorageService {
  RuckStorageService(this._sessions, this._prefs);

  final Box<RuckSession> _sessions;
  final Box _prefs;

  static const String _weightKey = 'last_weight_lbs';

  Future<void> save(RuckSession session) async {
    await _sessions.put(session.id, session);
    await _prefs.put(_weightKey, session.ruckWeightLbs);
  }

  List<RuckSession> listNewestFirst() {
    final List<RuckSession> items = _sessions.values.toList();
    items.sort((RuckSession a, RuckSession b) => b.startedAt.compareTo(a.startedAt));
    return items;
  }

  double? lastWeight() {
    final Object? value = _prefs.get(_weightKey);
    if (value is num) {
      return value.toDouble();
    }
    return null;
  }

  Future<void> delete(String id) => _sessions.delete(id);
}
