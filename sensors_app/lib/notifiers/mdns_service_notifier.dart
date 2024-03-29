import 'package:nsd/nsd.dart' as nsd;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mdns_service_notifier.g.dart';

@Riverpod(keepAlive: true)
FutureOr<nsd.Registration> mdnsService(mdnsServiceRefref) async {
  try {
    const nsd.Service service = nsd.Service(name: "FLUTTER", type: "_FLUTTER._udp", port: 5555);

    nsd.Registration registration = await nsd.register(service);

    print('registration successful');

    return registration;
  } catch (e) {
    throw Exception('Error in registering mDNS Service');
  }
}
