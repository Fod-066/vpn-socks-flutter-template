import 'package:drip_vpn/widget/grid_line.dart';
import 'package:flutter/material.dart';

class AppBack extends StatelessWidget {
  const AppBack({super.key, required this.body});
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff9AF4FF),
                  Colors.white,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: const GridLine(),
          ),
          body,
        ],
      ),
    );
  }
}
