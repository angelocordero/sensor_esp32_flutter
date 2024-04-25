// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:isar/isar.dart';

import 'package:sensors_app/constants.dart';

part 'sensor_data_class.g.dart';

@collection
class SensorData {
  String id;

  String name;

  int activations;

  @ignore
  DateTime? lastTransmitTime;
  @ignore
  SensorStatus status = SensorStatus.Disconnected;

  SensorData({required this.id, required this.name, this.status = SensorStatus.Disconnected, this.activations = 0});

  void setStatusActive() {
    lastTransmitTime = DateTime.now();
    status = SensorStatus.Active;
    activations++;
  }

  void setStatusConnected() {
    lastTransmitTime = DateTime.now();
    status = SensorStatus.Connected;
  }

  void checkIfDisconnected() {
    DateTime threeSecondsAgo = DateTime.now().subtract(const Duration(seconds: 10));

    if (lastTransmitTime?.isBefore(threeSecondsAgo) ?? true) {
      status = SensorStatus.Disconnected;
    }
  }

  SensorData copyWith({
    String? id,
    String? name,
    int? activations,
    DateTime? lastTransmitTime,
    SensorStatus? status,
  }) {
    return SensorData(
      id: id ?? this.id,
      name: name ?? this.name,
      activations: activations ?? this.activations,
      status: status ?? this.status,
    );
  }
}
