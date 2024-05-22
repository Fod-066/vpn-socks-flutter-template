import 'package:drip_vpn/screens/screens.dart';
import 'package:drip_vpn/widget/single_tapper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PerminumButton extends StatelessWidget {
  const PerminumButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleTapper(
      onTap: () => context.push(purchase),
      child: Container(
        constraints: const BoxConstraints.expand(height: 36, width: 130),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xff8a8a91)),
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.center,
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Go Premium',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            // AnimatedTextKit(
            //   animatedTexts: [
            //     ColorizeAnimatedText(
            //       'Go Premium',
            //       textStyle: peaceSans.copyWith(fontSize: 14),
            //       colors: [
            //         Colors.white54,
            //         Colors.white70,
            //         Colors.white,
            //       ],
            //     ),
            //   ],
            //   isRepeatingAnimation: true,
            //   repeatForever: true,
            // ),
            Icon(Icons.military_tech, color: Color(0xffffee5b))
          ],
        ),
      ),
    );
  }
}
