import 'package:baseline_pulse/core/utils/unit_format.dart';
import 'package:baseline_pulse/features/ruck/models/ruck_session.dart';
import 'package:baseline_pulse/features/run/models/run_prefs.dart';
import 'package:baseline_pulse/features/run/models/run_session.dart';
import 'package:baseline_pulse/features/run/models/run_split.dart';
import 'package:hive/hive.dart';

void registerHiveAdapters() {
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(RoutePointAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(RunSplitAdapter());
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(DistanceUnitAdapter());
  }
  if (!Hive.isAdapterRegistered(4)) {
    Hive.registerAdapter(SessionModeAdapter());
  }
  if (!Hive.isAdapterRegistered(5)) {
    Hive.registerAdapter(SessionTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(6)) {
    Hive.registerAdapter(RunSessionAdapter());
  }
  if (!Hive.isAdapterRegistered(7)) {
    Hive.registerAdapter(RunPrefsAdapter());
  }
  if (!Hive.isAdapterRegistered(8)) {
    Hive.registerAdapter(RuckSessionAdapter());
  }
}

class RoutePointAdapter extends TypeAdapter<RoutePoint> {
  @override
  final int typeId = 1;

  @override
  RoutePoint read(BinaryReader reader) {
    return RoutePoint(lat: reader.readDouble(), lng: reader.readDouble());
  }

  @override
  void write(BinaryWriter writer, RoutePoint obj) {
    writer
      ..writeDouble(obj.lat)
      ..writeDouble(obj.lng);
  }
}

class RunSplitAdapter extends TypeAdapter<RunSplit> {
  @override
  final int typeId = 2;

  @override
  RunSplit read(BinaryReader reader) {
    return RunSplit(
      index: reader.readInt(),
      elapsedSeconds: reader.readInt(),
      splitDistanceMeters: reader.readDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, RunSplit obj) {
    writer
      ..writeInt(obj.index)
      ..writeInt(obj.elapsedSeconds)
      ..writeDouble(obj.splitDistanceMeters);
  }
}

class DistanceUnitAdapter extends TypeAdapter<DistanceUnit> {
  @override
  final int typeId = 3;

  @override
  DistanceUnit read(BinaryReader reader) => DistanceUnit.values[reader.readInt()];

  @override
  void write(BinaryWriter writer, DistanceUnit obj) => writer.writeInt(obj.index);
}

class SessionModeAdapter extends TypeAdapter<SessionMode> {
  @override
  final int typeId = 4;

  @override
  SessionMode read(BinaryReader reader) => SessionMode.values[reader.readInt()];

  @override
  void write(BinaryWriter writer, SessionMode obj) => writer.writeInt(obj.index);
}

class SessionTypeAdapter extends TypeAdapter<SessionType> {
  @override
  final int typeId = 5;

  @override
  SessionType read(BinaryReader reader) => SessionType.values[reader.readInt()];

  @override
  void write(BinaryWriter writer, SessionType obj) => writer.writeInt(obj.index);
}

class RunSessionAdapter extends TypeAdapter<RunSession> {
  @override
  final int typeId = 6;

  @override
  RunSession read(BinaryReader reader) {
    return RunSession(
      id: reader.readString(),
      startedAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      endedAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      mode: SessionMode.values[reader.readInt()],
      sessionType: SessionType.values[reader.readInt()],
      unit: DistanceUnit.values[reader.readInt()],
      targetValue: reader.read(),
      durationSeconds: reader.readInt(),
      distanceMeters: reader.readDouble(),
      avgPaceSecondsPerUnit: reader.read(),
      gpsEnabled: reader.readBool(),
      splits: reader.readList().cast<RunSplit>(),
      routePreview: reader.readList().cast<RoutePoint>(),
      sessionScore: reader.readDouble(),
      fatigueIndex: reader.readDouble(),
      readinessScore: reader.readDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, RunSession obj) {
    writer
      ..writeString(obj.id)
      ..writeInt(obj.startedAt.millisecondsSinceEpoch)
      ..writeInt(obj.endedAt.millisecondsSinceEpoch)
      ..writeInt(obj.mode.index)
      ..writeInt(obj.sessionType.index)
      ..writeInt(obj.unit.index)
      ..write(obj.targetValue)
      ..writeInt(obj.durationSeconds)
      ..writeDouble(obj.distanceMeters)
      ..write(obj.avgPaceSecondsPerUnit)
      ..writeBool(obj.gpsEnabled)
      ..writeList(obj.splits)
      ..writeList(obj.routePreview)
      ..writeDouble(obj.sessionScore)
      ..writeDouble(obj.fatigueIndex)
      ..writeDouble(obj.readinessScore);
  }
}

class RunPrefsAdapter extends TypeAdapter<RunPrefs> {
  @override
  final int typeId = 7;

  @override
  RunPrefs read(BinaryReader reader) {
    return RunPrefs(autoUnit: reader.readBool(), unitOverride: reader.read());
  }

  @override
  void write(BinaryWriter writer, RunPrefs obj) {
    writer
      ..writeBool(obj.autoUnit)
      ..write(obj.unitOverride);
  }
}

class RuckSessionAdapter extends TypeAdapter<RuckSession> {
  @override
  final int typeId = 8;

  @override
  RuckSession read(BinaryReader reader) {
    return RuckSession(
      id: reader.readString(),
      startedAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      endedAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      mode: SessionMode.values[reader.readInt()],
      sessionType: SessionType.values[reader.readInt()],
      unit: DistanceUnit.values[reader.readInt()],
      targetValue: reader.read(),
      durationSeconds: reader.readInt(),
      distanceMeters: reader.readDouble(),
      avgPaceSecondsPerUnit: reader.read(),
      gpsEnabled: reader.readBool(),
      splits: reader.readList().cast<RunSplit>(),
      routePreview: reader.readList().cast<RoutePoint>(),
      ruckWeightLbs: reader.readDouble(),
      selectionMode: reader.readBool(),
      sessionScore: reader.readDouble(),
      fatigueIndex: reader.readDouble(),
      readinessScore: reader.readDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, RuckSession obj) {
    writer
      ..writeString(obj.id)
      ..writeInt(obj.startedAt.millisecondsSinceEpoch)
      ..writeInt(obj.endedAt.millisecondsSinceEpoch)
      ..writeInt(obj.mode.index)
      ..writeInt(obj.sessionType.index)
      ..writeInt(obj.unit.index)
      ..write(obj.targetValue)
      ..writeInt(obj.durationSeconds)
      ..writeDouble(obj.distanceMeters)
      ..write(obj.avgPaceSecondsPerUnit)
      ..writeBool(obj.gpsEnabled)
      ..writeList(obj.splits)
      ..writeList(obj.routePreview)
      ..writeDouble(obj.ruckWeightLbs)
      ..writeBool(obj.selectionMode)
      ..writeDouble(obj.sessionScore)
      ..writeDouble(obj.fatigueIndex)
      ..writeDouble(obj.readinessScore);
  }
}
