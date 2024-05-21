import 'dart:async';
import 'dart:convert';

import 'package:drip_vpn/channel/channel.dart';
import 'package:drip_vpn/logger/logger.dart';
import 'package:drip_vpn/screens/screens.dart';
import 'package:drip_vpn/vpn/pod.dart';
import 'package:drip_vpn/vpn/vpn_connect_time.dart';
import 'package:drip_vpn/vpn/vpn_profile.dart';
import 'package:drip_vpn/vpn/vpn_status.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulHookConsumerWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late StreamSubscription _n2fSub;
  VpnStatus lastVpnStatus = VpnStatus.idle;

  @override
  void initState() {
    super.initState();
    ref.read(vpnConnectTimeProvider.notifier).init();
    _n2fSub = n2fEventChannel.receiveBroadcastStream().listen(
      (e) {
        Logger.event(e);
        var event = jsonDecode(e);
        var eventName = event['name'];
        var eventData = event['data'];
        if (eventName == 'vpn_state_event') {
          _dealEvent(eventData);
        }
        if (eventName == 'profile_event') {
          ref.read(vpnProfileProvider.notifier).change(eventData);
        }
      },
      onError: (error) {},
      cancelOnError: false,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _n2fSub.cancel();
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

  Future<void> _dealEvent(dynamic event) async {
    var vpnStatus = _parseEvent(event);
    if (lastVpnStatus != vpnStatus) {
      ref.read(vpnStatusPod.notifier).change(vpnStatus);
      if (vpnStatus == VpnStatus.connected || vpnStatus == VpnStatus.stopped) {
        ref.read(vpnConnectTimeProvider.notifier).toggle(vpnStatus == VpnStatus.connected);
      }
      lastVpnStatus = vpnStatus;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: screens,
    );
  }
}
