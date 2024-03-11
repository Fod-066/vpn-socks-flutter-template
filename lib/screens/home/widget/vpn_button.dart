import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sweet_vpn/as/assets.dart';
import 'package:sweet_vpn/channel/channel.dart';
import 'package:sweet_vpn/vpn/vpn.dart';
import 'package:sweet_vpn/widget/style.dart';

class VpnButton extends HookConsumerWidget {
  const VpnButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var vpnStatus = ref.watch(vpnStatusPod);
    var isConnected = vpnStatus == VpnStatus.connected;
    return GestureDetector(
      onTap: () {
        nativeMethod.invokeMethod('toggle');
      },
      child: Container(
        constraints: BoxConstraints.expand(
          width: MediaQuery.of(context).size.width * 0.89,
          height: MediaQuery.of(context).size.height * 0.4,
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(isConnected ? Assets.assetsImgsImgConnected : Assets.assetsImgsImgStopped),
            Container(
              height: 46,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                color: isConnected ? const Color(0xffFFEC9A) : const Color(0xffFE8F47),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                isConnected ? 'Stop Connect' : 'Start Connect',
                style: peaceSans,
              ),
            )
          ],
        ),
      ),
    );
  }
}
