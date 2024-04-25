import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_app/notifiers/alarm_notifier.dart';
import 'package:sensors_app/notifiers/db_notifier.dart';
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
              onPressed: () {
                ref.read(dBNotifierProvider.notifier).refresh();
              },
              icon: const Icon(Icons.refresh),
            ),
            IconButton(
              onPressed: () async {
                String? id = ref.read(sensorsDataProvider).value?.first.id;
                if (id == null) return;
                ref.read(dBNotifierProvider.notifier).setSensorStatusActive(id);
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: const SensorDataList(),
      ),
    );
  }
}

class SensorDataList extends ConsumerStatefulWidget {
  const SensorDataList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SensorDataListState();
}

class _SensorDataListState extends ConsumerState<SensorDataList> {
  late final AudioPlayer player;
  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.loop);
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(sensorsDataProvider).when(
          skipLoadingOnRefresh: true,
          skipLoadingOnReload: false,
          data: (datas) {
            ref.listen<bool>(alarmNotifierProvider, (prev, next) {
              if (next == true) {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return Consumer(
                      builder: (context, ref, child) {
                        player.seek(Duration.zero);
                        player.play(AssetSource('alarm.mp3'));
                        ref.listen<bool>(alarmNotifierProvider, (prev, next) {
                          if (next == false) {
                            player.stop();
                            Navigator.pop(context);
                          }
                        });
                        return child!;
                      },
                      child: AlertDialog(
                        backgroundColor: const Color(0xffc72c41),
                        icon: const Icon(Icons.warning_amber),
                        title: const Text('SMOKE DETECTED'),
                        actions: [
                          TextButton(
                            style: ButtonStyle(
                              visualDensity: VisualDensity.compact,
                              foregroundColor: WidgetStateProperty.all(
                                Colors.white,
                              ),
                            ),
                            onPressed: () {
                              ref.read(alarmNotifierProvider.notifier).dismiss();
                            },
                            child: const Text('Dismiss'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            });

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
        );
  }
}
