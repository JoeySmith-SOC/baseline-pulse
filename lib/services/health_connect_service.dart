import 'package:health/health.dart';

class HealthConnectService {
  final Health _health = Health();

  Future<bool> requestPermissions() async {
    final bool? granted = await _health.requestAuthorization(
      <HealthDataType>[HealthDataType.STEPS, HealthDataType.HEART_RATE],
      permissions: <HealthDataAccess>[HealthDataAccess.READ, HealthDataAccess.READ],
    );
    return granted ?? false;
  }

  Future<bool> isConnected() async {
    return _health.hasPermissions(
          <HealthDataType>[HealthDataType.STEPS],
          permissions: <HealthDataAccess>[HealthDataAccess.READ],
        ) ??
        false;
  }

  Future<int?> readTodaySteps() async {
    final DateTime now = DateTime.now();
    final DateTime start = DateTime(now.year, now.month, now.day);
    final int? steps = await _health.getTotalStepsInInterval(start, now);
    return steps;
  }
}
