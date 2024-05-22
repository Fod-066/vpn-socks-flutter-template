import 'package:flutter/material.dart';

class AppBack extends StatelessWidget {
  const AppBack({super.key, required this.body});
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          color: Color(0xff262630),
        ),
        child: body,
      ),
    );
  }
}
