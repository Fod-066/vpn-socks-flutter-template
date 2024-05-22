import 'package:drip_vpn/as/assets.dart';
import 'package:drip_vpn/screens/screens.dart';
import 'package:drip_vpn/widget/app_back.dart';
import 'package:drip_vpn/widget/app_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class StartScreen extends StatefulHookConsumerWidget {
  const StartScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StartScreenState();
}

class _StartScreenState extends ConsumerState<StartScreen> with SingleTickerProviderStateMixin {
  // final double _progress = 0;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        context.pushReplacement(home);
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
    return AppBack(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(Assets.assetsImgsLogo, width: 113, height: 113),
              const SizedBox(height: 16),
              Transform.scale(
                scale: 1.5,
                child: const AppName().animate().fadeIn(duration: 1.5.seconds),
              ),
            ],
          ),
          const Spacer(),
          LoadingAnimationWidget.staggeredDotsWave(color: Colors.white, size: 80),
          const Spacer(),
        ],
      ),
    );
  }
}
