import 'package:drip_vpn/ext/number.dart';
import 'package:drip_vpn/vpn/vpn.dart';
import 'package:drip_vpn/widget/style.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ConnectTimer extends HookConsumerWidget {
  const ConnectTimer({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var vpnStatus = ref.watch(vpnStatusPod);
    var isUseBlackTextColor = vpnStatus == VpnStatus.connected ||
        vpnStatus == VpnStatus.connecting ||
        vpnStatus == VpnStatus.switching ||
        vpnStatus == VpnStatus.stopping;
    var seconds = ref.watch(vpnConnectTimeProvider);
    return Text(
      isUseBlackTextColor ? seconds.formatDuration() : '00:00:00',
      style: peaceSans.copyWith(
        color: Colors.white,
        fontSize: 36,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
