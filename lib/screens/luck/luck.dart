import 'package:drip_vpn/as/assets.dart';
import 'package:drip_vpn/screens/luck/luck_pan.dart';
import 'package:drip_vpn/widget/app_back.dart';
import 'package:drip_vpn/widget/single_tapper.dart';
import 'package:drip_vpn/widget/style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LuckScreen extends StatefulHookConsumerWidget {
  const LuckScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LuckScreenState();
}

class _LuckScreenState extends ConsumerState<LuckScreen> {
  bool isLucking = true;
  int number = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !isLucking,
      child: AppBack(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isLucking) ...[
              const Spacer(),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LuckPan(
                    onFinished: (value) {
                      setState(() {
                        isLucking = false;
                        number = value;
                      });
                    },
                  ),
                  const Text('Number test…', style: peaceSans),
                ],
              ),
              const Spacer(),
            ],
            if (!isLucking) ...[
              const SizedBox(height: 32),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 56,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 0,
                      child: IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ),
                    const Text('Today\'s lucky number', style: peaceSans),
                  ],
                ),
              ),
              const SizedBox(height: 16),
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
                        padding: const EdgeInsets.only(right: 12, left: 48),
                        decoration: const BoxDecoration(
                          image: DecorationImage(image: AssetImage(Assets.assetsImgsImgGlassBox)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              number.toString(),
                              style: peaceSans.copyWith(fontSize: 32),
                            ),
                            Text(
                              'Lucky numbers are numbers that bring luck to someone.\nGenerally refers to a number that brings luck to someone in some way.',
                              style: peaceSans.copyWith(color: const Color(0xFFACE0FD), fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      child: Image.asset(
                        Assets.assetsImgsImgYes,
                        width: 144,
                        height: 168,
                      ),
                    ),
                  ],
                ),
              ),
              SingleTapper(
                onTap: () {
                  setState(() {
                    isLucking = true;
                  });
                },
                child: Container(
                  height: 46,
                  margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 32),
                  decoration: BoxDecoration(
                    color: const Color(0xffFE8F47),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Restart',
                    style: peaceSans.copyWith(color: Colors.white),
                  ),
                ),
              ),
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
                    const Text('The Fasters nodes', style: peaceSans),
                    const Spacer(),
                    Image.asset(Assets.assetsImgsIconNext, width: 34, height: 34),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
