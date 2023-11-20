import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_app/sensor_app.dart';

void main() {
  runApp(
    const ProviderScope(
      child: SensorApp(),
    ),
  );
}
