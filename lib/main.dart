import 'dart:async';

import 'package:access_vpn/channel/channel.dart';
import 'package:access_vpn/vpn/pod.dart';
import 'package:access_vpn/vpn/vpn_status.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child:  MyApp()));
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
      },
      onError: (error) {},
      cancelOnError: false,
    );
  }

  Future<void> _dealEvent(dynamic event) async {
    var vpnStatus = _parseEvent(event);
    ref.read(vpnStatusPod.notifier).change(vpnStatus);
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
    return MaterialApp(
      title: 'Access Vpn',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(ref.watch(vpnStatusPod).name),
              ElevatedButton(
                onPressed: () {
                  nativeMethod.invokeMethod('toggle');
                },
                child: const Text('toggle'),
              ),
            ],
          ),
        ),
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
