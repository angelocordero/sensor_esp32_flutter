import 'dart:convert';
import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sensors_app/notifiers/db_notifier.dart';

import '../classes/sensor_data_class.dart';

part 'udp_socket_notifier.g.dart';

@Riverpod(keepAlive: true)
FutureOr<RawDatagramSocket> udpSocket(UdpSocketRef ref) async {
  try {
    RawDatagramSocket socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 5001);
    _listenForSensorData(socket, ref);
    return socket;
  } catch (e) {
    throw Exception('Error in opening UDP Socket');
  }
}

_listenForSensorData(RawDatagramSocket socket, ref) async {
  List<SensorData> datas = await ref.watch(dBNotifierProvider.future);

  socket.listen(
    (RawSocketEvent event) {
      final datagram = socket.receive();

      List<int>? list = datagram?.data.toList();

      if (list == null) return;

      String data = utf8.decode(list);

      Map<String, dynamic> jsonData = jsonDecode(data);

      String id = jsonData['id'];
      String status = jsonData['status'];

      if (datas.any((element) => element.id == id)) {
        if (status == 'connected') {
          ref.read(dBNotifierProvider.notifier).setSensorStatusConnected(id);
        } else if (status == 'active') {
          ref.read(dBNotifierProvider.notifier).setSensorStatusActive(id);
        }
        return;
      }

      ref.read(dBNotifierProvider.notifier).addSensor(id);
    },
  );
}
