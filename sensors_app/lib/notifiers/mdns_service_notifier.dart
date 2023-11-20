import 'package:nsd/nsd.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mdns_service_notifier.g.dart';

@Riverpod(keepAlive: true)
FutureOr<Registration> mdnsService(mdnsServiceRefref) async {
  try {
    const Service service = Service(name: "FLUTTER", type: "_FLUTTER._udp", port: 5555);
    return await register(service);
  } catch (e) {
    throw Exception('Error in registering mDNS Service');
  }
}
