import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sensors_app/constants.dart';
import 'package:sensors_app/notifiers/sensors_data_notifier.dart';

part 'alarm_notifier.g.dart';

@Riverpod(keepAlive: true)
class AlarmNotifier extends _$AlarmNotifier {
  Set<String> activeAlarms = {};

  @override
  bool build() {
    ref.listen(sensorsDataProvider, (prev, next) {
      Set<String> tmp = next.value?.where((element) => element.status == SensorStatus.Active).map((e) => e.id).toSet() ?? <String>{};

      if (activeAlarms != tmp && tmp.length > activeAlarms.length) {
        activeAlarms = tmp;
        state = true;
      } else if (tmp.isEmpty) {
        activeAlarms = {};
        state = false;
      }
    });

    return false;
  }

  void dismiss() {
    state = false;
  }
}
