import 'package:drip_vpn/as/assets.dart';
import 'package:drip_vpn/channel/channel.dart';
import 'package:drip_vpn/screens/screens.dart';
import 'package:drip_vpn/vpn/vpn.dart';
import 'package:drip_vpn/widget/app_back.dart';
import 'package:drip_vpn/widget/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ExecuteScreen extends StatefulHookConsumerWidget {
  const ExecuteScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExecuteScreenState();
}

class _ExecuteScreenState extends ConsumerState<ExecuteScreen> with SingleTickerProviderStateMixin {
  var vpnStatus;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    var isConnecting = ref.read(vpnStatusPod).isConnecting;
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: -1).animate(_controller);

    _controller.forward();

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //context.pushReplacement(home);
        if (!isConnecting) {
          nativeMethod.invokeMethod('stop');
        }
        context.pushReplacement(result);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isConnecting = ref.watch(vpnStatusPod).isConnecting;

    return WillPopScope(
      onWillPop: () async => false,
      child: AppBack(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(
              Assets.assetsImgsImgStopped,
              width: MediaQuery.of(context).size.width * 0.89,
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            Text(
              isConnecting ? 'watermelon connecting..... ' : 'watermelon disconnecting.....',
              style: peaceSans.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 240,
              height: 7,
              child: Stack(
                children: [
                  Image.asset(
                    Assets.assetsImgsImgPb,
                    fit: BoxFit.fill,
                  ),
                  AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Positioned(
                          right: _animation.value * 240,
                          child: Container(
                            width: 240,
                            height: 7,
                            decoration:
                                BoxDecoration(borderRadius: BorderRadius.circular(3.5), color: const Color(0xFFCDF8FE)),
                          ),
                        );
                      })
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
