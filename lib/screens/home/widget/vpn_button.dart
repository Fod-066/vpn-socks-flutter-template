import 'package:drip_vpn/vpn/vpn.dart';
import 'package:drip_vpn/widget/style.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VpnButton extends HookConsumerWidget {
  const VpnButton({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(vpnStatusPod);
    var isConnected = state.isConnetced;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 208,
            width: 102,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(66),
              color: const Color(0xff191b20),
              border: Border.all(
                color: isConnected ? const Color(0xffcef27e) : const Color(0xffd80128),
                width: 4,
              ),
            ),
            child: SizedBox.expand(
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Positioned(
                    top: 24,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'On',
                          style: peaceSans.copyWith(color: Colors.white),
                        ),
                        const Icon(Icons.arrow_drop_up, color: Colors.white),
                        const Icon(Icons.arrow_drop_up, color: Colors.white54),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 24,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.arrow_drop_down, color: Colors.white54),
                        const Icon(Icons.arrow_drop_down, color: Colors.white),
                        Text(
                          'Off',
                          style: peaceSans.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    top: isConnected ? 0 : 106,
                    child: Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            isConnected ? const Color(0xffcef27e) : const Color(0xffd80128),
                            if (!isConnected) const Color(0xffd80128),
                            const Color(0xffcef27e),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.power_settings_new,
                          color: isConnected ? const Color(0xffcef27e) : const Color(0xffd80128),
                          size: 24,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          isConnected ? 'Tap to disconnect' : 'Tap to connect',
          style: peaceSans.copyWith(
            color: Colors.white54,
          ),
        )
      ],
    );
  }
}

class MyGlobalEffects {}
