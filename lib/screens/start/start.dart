import 'package:drip_vpn/as/assets.dart';
import 'package:drip_vpn/screens/screens.dart';
import 'package:drip_vpn/widget/app_back.dart';
import 'package:drip_vpn/widget/style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Opacity(
                opacity: _animation.value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      Assets.assetsImgsLogo,
                      width: 160,
                      height: 160,
                    ),
                    Text(
                      'Sweet Watermelon',
                      style: peaceSans.copyWith(fontSize: 18),
                    ),
                  ],
                ),
              );
            },
          ),
          const Spacer(),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return LinearProgressIndicator(
                backgroundColor: const Color(0xff79CDD7),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                value: _animation.value,
                minHeight: 6,
              );
            },
          ),
        ],
      ),
    );
  }
}
