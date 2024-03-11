import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sweet_vpn/channel/channel.dart';
import 'package:sweet_vpn/screens/screens.dart';
import 'package:sweet_vpn/vpn/vpn.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulHookConsumerWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late StreamSubscription _streamSubscription;
  late StreamSubscription _profileSubscription;

  @override
  void initState() {
    super.initState();
    ref.read(vpnConnectTimeProvider.notifier).init();
    _streamSubscription = vpnStatusEventChannel.receiveBroadcastStream().listen(
      (event) {
        print('received event $event');
        _dealEvent(event);
      },
      onError: (error) {},
      cancelOnError: false,
    );
    _profileSubscription = profileEventChannel.receiveBroadcastStream().listen(
      (event) {
        print('received profile $event');
        ref.read(vpnProfileProvider.notifier).change(event);
      },
      onError: (error) {},
      cancelOnError: false,
    );
  }

  Future<void> _dealEvent(dynamic event) async {
    var vpnStatus = _parseEvent(event);
    ref.read(vpnStatusPod.notifier).change(vpnStatus);
    if (vpnStatus == VpnStatus.connected || vpnStatus == VpnStatus.stopped) {
      ref.read(vpnConnectTimeProvider.notifier).toggle(vpnStatus == VpnStatus.connected);
    }
  }

  VpnStatus _parseEvent(dynamic event) {
    if (event is String) {
      return VpnStatus.values.firstWhere(
        (element) => element.name == event,
        orElse: () => VpnStatus.idle,
      );
    }
    return VpnStatus.idle;
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        routerConfig: screens,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
    _profileSubscription.cancel();
  }
}
