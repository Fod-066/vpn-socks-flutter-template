import 'package:drip_vpn/as/assets.dart';
import 'package:drip_vpn/screens/screens.dart';
import 'package:drip_vpn/widget/single_tapper.dart';
import 'package:drip_vpn/widget/style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TodayLucky extends StatelessWidget {
  const TodayLucky({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleTapper(
      onTap: () => context.push(luck),
      child: Container(
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
            Image.asset(Assets.assetsImgsIconNumber, width: 46, height: 46),
            const SizedBox(width: 4),
            const Text('Today\'s lucky numbers', style: peaceSans),
            const Spacer(),
            Image.asset(Assets.assetsImgsIconNext, width: 34, height: 34),
          ],
        ),
      ),
    );
  }
}
