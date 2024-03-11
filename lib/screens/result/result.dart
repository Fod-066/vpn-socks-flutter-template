import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sweet_vpn/as/assets.dart';
import 'package:sweet_vpn/ext/number.dart';
import 'package:sweet_vpn/screens/home/widget/widget.dart';
import 'package:sweet_vpn/vpn/vpn.dart';
import 'package:sweet_vpn/widget/app_back.dart';
import 'package:sweet_vpn/widget/style.dart';

class ResultScreen extends StatefulHookConsumerWidget {
  const ResultScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    var vpnStatus = ref.watch(vpnStatusPod);
    return AppBack(
        body: Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 32),
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.88,
          height: 168,
          child: Stack(
            children: [
              Positioned(
                right: 0,
                child: Container(
                  width: 240,
                  height: 168,
                  padding: const EdgeInsets.only(right: 12),
                  decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage(Assets.assetsImgsImgGlassBox)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        vpnStatus.isConnetced ? 'Successfully connected' : 'Successfully disconnected',
                        style: peaceSans,
                      ),
                      const ResultTimer(),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                child: Image.asset(
                  vpnStatus.isConnetced ? Assets.assetsImgsImgYes : Assets.assetsImgsImgNot,
                  width: 144,
                  height: 168,
                ),
              ),
            ],
          ),
        ),
        if (!vpnStatus.isConnetced)
          Container(
            height: 46,
            margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
            decoration: BoxDecoration(
              color: const Color(0xffFE8F47),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Text(
              'Connect again',
              style: peaceSans,
            ),
          ),
        if (vpnStatus.isConnetced) ...[
          const SizedBox(height: 48),
          Container(
            width: MediaQuery.of(context).size.width * 0.89,
            height: 66,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset(Assets.assetsImgsImgNode, width: 46, height: 46),
                const SizedBox(width: 4),
                const Text('Change nodes', style: peaceSans),
                const Spacer(),
                Image.asset(Assets.assetsImgsIconNext, width: 34, height: 34),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        const TodayLucky(),
      ],
    ));
  }
}

class ResultTimer extends HookConsumerWidget {
  const ResultTimer({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var seconds = ref.watch(vpnConnectTimeProvider);
    var isConnected = ref.watch(vpnStatusPod).isConnetced;
    var texts = seconds.formatDuration().split(':');
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isConnected ? const Color(0xff6CF62A) : const Color(0xffFFB14B),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: Text(texts.first, style: peaceSans.copyWith(color: Colors.white)),
        ),
        const Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(':', style: peaceSans),
        ),
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isConnected ? const Color(0xff6CF62A) : const Color(0xffFFB14B),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(texts[1], style: peaceSans.copyWith(color: Colors.white)),
        ),
        const Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(':', style: peaceSans),
        ),
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isConnected ? const Color(0xff6CF62A) : const Color(0xffFFB14B),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(texts.last, style: peaceSans.copyWith(color: Colors.white)),
        ),
      ],
    );
  }
}
