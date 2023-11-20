import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_app/notifiers/sensors_data_notifier.dart';
import 'package:sensors_app/widgets/sensor_list_tile.dart';

import 'classes/sensor_data_class.dart';

class SensorApp extends ConsumerWidget {
  const SensorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: ThemeData.dark(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 4,
          elevation: 4,
          title: const Text('Sensor App'),
          actions: [
            IconButton(
              onPressed: () async {
                await ref.read(sensorsDataProvider.notifier).refresh();
              },
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: ref.watch(sensorsDataProvider).when(
              data: (datas) {
                return ListView.builder(
                  itemCount: datas.length,
                  itemBuilder: (context, index) {
                    SensorData data = datas[index];

                    return SensorListTile(
                      data: data,
                    );
                  },
                );
              },
              error: (e, st) => Center(
                child: Text(
                  e.toString(),
                ),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
      ),
    );
  }
}
