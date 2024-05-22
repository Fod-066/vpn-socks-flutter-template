import 'package:drip_vpn/config/color_const.dart';
import 'package:drip_vpn/screens/screens.dart';
import 'package:drip_vpn/vpn/vpn.dart';
import 'package:drip_vpn/widget/style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ConnectProfile extends HookConsumerWidget {
  const ConnectProfile({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(vpnStatusPod);
    var profileName = ref.watch(vpnProfileProvider)?.name ?? '';
    return state.isConnetced
        ? GestureDetector(
            onTap: () {
              context.push(servers);
            },
            child: Container(
              width: 258,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: const Color(0x775b5b62),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.share_location_sharp,
                    color: connectColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    profileName,
                    style: peaceSans.copyWith(color: connectColor),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_circle_right_outlined,
                    color: connectColor,
                  )
                ],
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
