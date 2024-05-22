import 'package:flutter/material.dart';

class AppName extends StatelessWidget {
  const AppName({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Drip ', style: TextStyle(color: Colors.white70, fontSize: 18)),
        Text(
          'VPN',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        )
      ],
    );
  }
}
