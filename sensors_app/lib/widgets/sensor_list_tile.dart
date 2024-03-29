import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_app/constants.dart';
import 'package:sensors_app/notifiers/db_notifier.dart';

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
        title: Text(data.name),
        subtitle: Text(data.status.name),
        tileColor: switch (data.status) {
          SensorStatus.Active => Colors.deepOrange.shade900,
          SensorStatus.Connected => Colors.indigo,
          SensorStatus.Disconnected => Colors.blueGrey.shade700,
        },
        trailing: PopupMenu(data),
        leading: switch (data.status) {
          SensorStatus.Active => const Icon(Icons.warning),
          SensorStatus.Connected => const Icon(Icons.check),
          SensorStatus.Disconnected => const Icon(Icons.close)
        },
      ),
    );
  }
}

class PopupMenu extends ConsumerWidget {
  const PopupMenu(this.data, {super.key});

  final SensorData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: const Text('Rename'),
            onTap: () {
              TextEditingController controller = TextEditingController();
              controller.text = data.name;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Rename Sensor'),
                    content: TextField(
                      controller: controller,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          ref.read(dBNotifierProvider.notifier).renameSensor(data.id, controller.text.trim());
                        },
                        child: const Text('Confirm'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          PopupMenuItem(
            child: const Text('Delete'),
            onTap: () {
              ref.read(dBNotifierProvider.notifier).deleteSensor(data.id);
            },
          ),
        ];
      },
    );
  }
}
