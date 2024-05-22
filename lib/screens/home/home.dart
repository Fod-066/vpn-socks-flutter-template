import 'package:drip_vpn/as/assets.dart';
import 'package:drip_vpn/channel/channel.dart';
import 'package:drip_vpn/screens/home/widget/widget.dart';
import 'package:drip_vpn/screens/screens.dart';
import 'package:drip_vpn/vpn/pod.dart';
import 'package:drip_vpn/vpn/vpn_status.dart';
import 'package:drip_vpn/widget/app_back.dart';
import 'package:drip_vpn/widget/app_name.dart';
import 'package:drip_vpn/widget/loading_dialog.dart';
import 'package:drip_vpn/widget/permium_button.dart';
import 'package:drip_vpn/widget/single_tapper.dart';
import 'package:drip_vpn/widget/speed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends StatefulHookConsumerWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  var _isShowingLoadingDialog = false;

  @override
  void initState() {
    super.initState();
    ref.listenManual(vpnStatusPod, (previous, next) {
      if (next.isExecuting) {
        LoadingDialog.show(context);
        _isShowingLoadingDialog = true;
      } else {
        if (_isShowingLoadingDialog) {
          context.pop();
          _isShowingLoadingDialog = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBack(
      body: Stack(
        children: [
          Positioned(
            top: 180,
            left: 0,
            right: 0,
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(Color(0xff262630), BlendMode.color),
              child: Image.asset(Assets.assetsImgsWorld),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SingleTapper(
                      child: const AppName(),
                      onTap: () => context.push(setting),
                    ),
                    const PerminumButton(),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              // ConnectProfile(),
              const SizedBox(height: 14),
              const ConnectTimer(),
              const SizedBox(height: 56),
              VpnButton(
                onTap: () {
                  nativeMethod.invokeMethod('toggle');
                },
              ),
              const SizedBox(height: 48),
              const Speeder(),
              const SizedBox(height: 56),
              const ConnectProfile(),
            ],
          ),
        ],
      ),
    );
  }
}
