import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sensors_app/classes/sensor_data_class.dart';
import 'package:sensors_app/notifiers/db_notifier.dart';

import 'mdns_service_notifier.dart';
import 'udp_socket_notifier.dart';

part 'sensors_data_notifier.g.dart';

@Riverpod(keepAlive: true)
class SensorsData extends _$SensorsData {
  @override
  FutureOr<List<SensorData>> build() async {
    final timer = Timer(const Duration(seconds: 1), () {
      ref.invalidateSelf();
    });

    ref.onDispose(() {
      timer.cancel();
    });

    await ref.read(mdnsServiceProvider.future);
    await ref.read(udpSocketProvider.future);

    List<SensorData> data = ref.watch(dBNotifierProvider).valueOrNull ?? [];

    for (var element in data) {
      element.checkIfDisconnected();
    }

    return data;
  }
}
