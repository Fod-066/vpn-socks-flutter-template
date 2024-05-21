import 'package:drip_vpn/as/assets.dart';
import 'package:drip_vpn/channel/channel.dart';
import 'package:drip_vpn/screens/setting/setting_button.dart';
import 'package:drip_vpn/widget/app_back.dart';
import 'package:drip_vpn/widget/style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return AppBack(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          const SizedBox(height: 50),
          Image.asset(Assets.assetsImgsLogo, width: 113, height: 113),
          Text(
            'Sweet Watermelon',
            style: peaceSans.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 44),
          SettingButton(text: 'Privacy Policy', onTap: () => nativeMethod.invokeMethod('openBrowser')),
          const SizedBox(height: 16),
          SettingButton(text: 'Rate us', onTap: () => nativeMethod.invokeMethod('openGp')),
          const SizedBox(height: 16),
          SettingButton(text: 'Share us', onTap: () => nativeMethod.invokeMethod('openGp')),
          const SizedBox(height: 16),
          SettingButton(text: 'Version: v1.0.0', onTap: () {}),
        ],
      ),
    );
  }
}
