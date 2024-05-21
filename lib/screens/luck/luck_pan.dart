import 'dart:math' as math;

import 'package:drip_vpn/as/assets.dart';
import 'package:flutter/material.dart';

class LuckPan extends StatefulWidget {
  const LuckPan({super.key, required this.onFinished});
  final ValueChanged<int> onFinished;

  @override
  _LuckPanState createState() => _LuckPanState();
}

class _LuckPanState extends State<LuckPan> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _rotationAngle = 0.0;
  late int _randomIndex;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween(begin: 0.0, end: math.pi * 4).animate(_controller)
      ..addListener(() {
        setState(() {
          _rotationAngle = _animation.value;
        });
      });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _randomIndex = math.Random().nextInt(10);
          _rotationAngle = _randomIndex * math.pi / 5;
          widget.onFinished(_randomIndex);
        });
      }
    });

    // 开始动画
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          Assets.assetsImgsImgNpBg,
          width: 256,
          height: 256,
        ),
        Transform.rotate(
          angle: _rotationAngle,
          child: Image.asset(
            Assets.assetsImgsImgNp,
            width: 256,
            height: 256,
          ),
        ),
        Image.asset(
          Assets.assetsImgsImgNpPoint,
          width: 256,
          height: 256,
        ),
      ],
    );
  }
}
