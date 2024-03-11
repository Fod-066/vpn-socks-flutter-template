import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sweet_vpn/channel/channel.dart';
import 'package:sweet_vpn/screens/home/widget/widget.dart';
import 'package:sweet_vpn/screens/screens.dart';
import 'package:sweet_vpn/vpn/pod.dart';
import 'package:sweet_vpn/vpn/vpn_connect_time.dart';
import 'package:sweet_vpn/vpn/vpn_profile.dart';
import 'package:sweet_vpn/vpn/vpn_status.dart';
import 'package:sweet_vpn/widget/app_back.dart';
import 'package:sweet_vpn/widget/style.dart';

class HomeScreen extends StatefulHookConsumerWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late StreamSubscription _streamSubscription;
  late StreamSubscription _profileSubscription;
  VpnStatus lastVpnStatus = VpnStatus.idle;

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
    if (vpnStatus.isExecuting && lastVpnStatus != vpnStatus) {
      context.push(executing);
    }
    lastVpnStatus = vpnStatus;
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
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
    _profileSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return AppBack(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sweet \nWatermelon',
                  style: peaceSans.copyWith(color: const Color(0xffACE0FD)),
                ),
                IconButton(
                  onPressed: () => context.push(setting),
                  icon: const Icon(Icons.settings),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const ConnectProfile(),
          const SizedBox(height: 14),
          const ConnectTimer(),
          const VpnButton(),
          const SizedBox(height: 32),
          const TodayLucky(),
        ],
      ),
    );
  }
}
