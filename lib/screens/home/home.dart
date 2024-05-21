import 'package:drip_vpn/screens/home/widget/widget.dart';
import 'package:drip_vpn/screens/screens.dart';
import 'package:drip_vpn/vpn/pod.dart';
import 'package:drip_vpn/vpn/vpn_status.dart';
import 'package:drip_vpn/widget/app_back.dart';
import 'package:drip_vpn/widget/style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends StatefulHookConsumerWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ref.listenManual(vpnStatusPod, (previous, next) {
      if (next.isExecuting) {
        context.push(executing);
      }
    });
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
