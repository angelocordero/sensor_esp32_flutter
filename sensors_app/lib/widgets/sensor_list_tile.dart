import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_app/constants.dart';

import '../classes/sensor_data_class.dart';

class SensorListTile extends ConsumerWidget {
  const SensorListTile({super.key, required this.data});

  final SensorData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: ListTile(
        visualDensity: VisualDensity.compact,
        shape: const StadiumBorder(
          side: BorderSide(
            width: 1,
            color: Colors.black,
          ),
        ),
        title: Text(data.id),
        subtitle: Text(data.status.name),
        tileColor: switch (data.status) {
          SensorStatus.Active => Colors.deepOrange.shade900,
          SensorStatus.Connected => Colors.indigo,
          SensorStatus.Disconnected => Colors.blueGrey.shade700,
        },
        trailing: const Icon(Icons.more_vert),
        leading: switch (data.status) {
          SensorStatus.Active => const Icon(Icons.warning),
          SensorStatus.Connected => const Icon(Icons.check),
          SensorStatus.Disconnected => const Icon(Icons.close)
        },
      ),
    );
  }
}
