import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sensors_app/classes/sensor_data_class.dart';

part 'db_notifier.g.dart';

@Riverpod(keepAlive: true)
class DBNotifier extends _$DBNotifier {
  Isar? db;

  @override
  FutureOr<List<SensorData>> build() async {
    final Directory dir = await getApplicationSupportDirectory();

    db = Isar.open(schemas: [SensorDataSchema], directory: dir.path, inspector: true);

    return db?.sensorDatas.where().findAll() ?? [];
  }

  void addSensor(String id) async {
    if (db == null) return;

    SensorData data = SensorData(id: id, name: id);

    db!.writeAsync((isar) {
      isar.sensorDatas.put(data);
    });

    ref.invalidateSelf();
  }

  void deleteSensor(String id) async {
    if (db == null) return;

    db!.writeAsync((isar) {
      isar.sensorDatas.delete(id);
    });

    ref.invalidateSelf();
  }

  Future<void> renameSensor(String id, String newName) async {
    if (db == null) throw Exception('Null DB');

    try {
      await db!.writeAsync((isar) {
        final SensorData data = SensorData(id: id, name: newName);
        isar.sensorDatas.put(data);
      });

      // await refresh();
      ref.invalidateSelf();
    } catch (e) {
      throw Exception();
    }
  }

  void setSensorStatusConnected(String id) {
    state.value!.firstWhere((element) => element.id == id).setStatusConnected();
  }

  void setSensorStatusActive(String id) {
    if (db == null) throw Exception('Null DB');

    try {
      db!.write((isar) {
        SensorData data = isar.sensorDatas.where().idEqualTo(id).findFirst()!;

        SensorData newData = data.copyWith(activations: data.activations + 1);

        isar.sensorDatas.put(newData);
      });

      state.value!.firstWhere((element) => element.id == id).setStatusActive();
    } catch (e) {
      throw Exception();
    }
  }

  refresh() {
    ref.invalidateSelf();
  }
}
