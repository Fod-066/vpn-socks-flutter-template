import 'package:flutter/material.dart';
import 'package:sweet_vpn/widget/single_tapper.dart';
import 'package:sweet_vpn/widget/style.dart';

// ignore: must_be_immutable
class SettingButton extends StatelessWidget {
  SettingButton({super.key, required this.text, required this.onTap, this.showNext = true});
  final String text;
  final VoidCallback onTap;
  bool showNext = true;

  @override
  Widget build(BuildContext context) {
    return SingleTapper(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.89,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: peaceSans),
            if (showNext) const Icon(Icons.navigate_next),
          ],
        ),
      ),
    );
  }
}
