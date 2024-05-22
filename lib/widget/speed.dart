import 'package:drip_vpn/config/color_const.dart';
import 'package:drip_vpn/ext/number.dart';
import 'package:drip_vpn/vpn/vpn.dart';
import 'package:drip_vpn/widget/style.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Speeder extends StatefulHookConsumerWidget {
  const Speeder({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SpeederState();
}

class _SpeederState extends ConsumerState<Speeder> {
  // late Timer timer;
  // var downSpeed = 10.0;
  // var loadSpeed = 10.0;

  @override
  void initState() {
    super.initState();
    // timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    //   setState(() {
    //     downSpeed = Random().nextDouble() * 20 + 80;
    //     loadSpeed = Random().nextDouble() * 20 + 60;
    //   });
    // });
  }

  @override
  void dispose() {
    super.dispose();
    // timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(vpnStatusPod);
    var isConnected = state.isConnetced;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Speed', style: peaceSans.copyWith(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 12),
        Container(
          width: MediaQuery.of(context).size.width * 0.68,
          height: 48,
          decoration: const BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.expand_more,
                        color: connectColor,
                      ),
                      Text(isConnected ? ref.watch(vpnTrafficPod).txRate.formatBytes() : '0', style: peaceSans),
                    ],
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 24,
                decoration: const BoxDecoration(color: Colors.white),
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.expand_less,
                        color: normalColor,
                      ),
                      Text(state.isConnetced ? ref.watch(vpnTrafficPod).rxRate.formatBytes() : '0', style: peaceSans),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
