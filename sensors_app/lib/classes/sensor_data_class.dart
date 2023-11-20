// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:isar/isar.dart';
import 'package:sensors_app/constants.dart';

part 'sensor_data_class.g.dart';

@collection
class SensorData {
  String id;

  @ignore
  DateTime? lastTransmitTime;
  @ignore
  SensorStatus status = SensorStatus.Disconnected;

  SensorData({required this.id, this.status = SensorStatus.Disconnected});

  void setStatusActive() {
    lastTransmitTime = DateTime.now();
    status = SensorStatus.Active;
  }

  void setStatusConnected() {
    lastTransmitTime = DateTime.now();
    status = SensorStatus.Connected;
  }

  void checkIfDisconnected() {
    DateTime threeSecondsAgo = DateTime.now().subtract(const Duration(seconds: 3));

    if (lastTransmitTime?.isBefore(threeSecondsAgo) ?? true) {
      status = SensorStatus.Disconnected;
    }
  }
}
