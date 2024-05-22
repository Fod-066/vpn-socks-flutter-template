import 'package:drip_vpn/widget/single_tapper.dart';
import 'package:drip_vpn/widget/style.dart';
import 'package:flutter/material.dart';

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
        width: MediaQuery.of(context).size.width * 0.8,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xff17191e),
          borderRadius: BorderRadius.circular(31),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: peaceSans),
            if (showNext) const Icon(Icons.navigate_next, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
