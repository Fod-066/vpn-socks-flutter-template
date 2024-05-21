import 'package:drip_vpn/channel/channel.dart';
import 'package:drip_vpn/screens/sever/server_list.dart';
import 'package:drip_vpn/widget/app_back.dart';
import 'package:drip_vpn/widget/style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ServersScreen extends StatefulHookConsumerWidget {
  const ServersScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ServersScreenState();
}

class _ServersScreenState extends ConsumerState<ServersScreen> {
  @override
  Widget build(BuildContext context) {
    return AppBack(
        body: Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 32),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 56,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 0,
                child: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              const Text('Servers', style: peaceSans),
            ],
          ),
        ),
        Expanded(
          child: ServerList(
            onServerItemClick: (id) {
              nativeMethod.invokeMethod('switch', id);
              //GoRouter.of(context).go(home);
              context.pop(true);
            },
          ),
        )
      ],
    ));
  }
}
