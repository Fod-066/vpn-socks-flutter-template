import 'package:drip_vpn/as/assets.dart';
import 'package:drip_vpn/vpn/vpn.dart';
import 'package:drip_vpn/widget/style.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ConnectProfile extends HookConsumerWidget {
  const ConnectProfile({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var profileName = ref.watch(vpnProfileProvider)?.name ?? '';
    return Container(
      width: 258,
      height: 44,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.assetsImgsImgProfileBg),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        'Smart Location: $profileName',
        style: peaceSans.copyWith(color: Colors.white),
      ),
    );
  }
}
