import 'dart:convert';

import 'package:drip_vpn/as/assets.dart';
import 'package:drip_vpn/channel/channel.dart';
import 'package:drip_vpn/vpn/vpn_profile.dart';
import 'package:drip_vpn/widget/single_tapper.dart';
import 'package:drip_vpn/widget/style.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef OnServerItemClick = Function(int);

class ServerList extends ConsumerStatefulWidget {
  const ServerList({super.key, required this.onServerItemClick});

  final OnServerItemClick onServerItemClick;

  @override
  ConsumerState createState() => _ServerListState();
}

class _ServerListState extends ConsumerState<ServerList> {
  List<VpnProfile>? _profiles;

  @override
  void initState() {
    super.initState();
    prepareProfiles();
  }

  Future<void> prepareProfiles() async {
    var profiles = await nativeMethod.invokeMethod("getAllProfiles");
    List<dynamic> ja = jsonDecode(profiles);
    if (ja.isNotEmpty) {
      setState(() {
        _profiles = List.from(
          ja.map(
            (e) => VpnProfile(name: e['name'], host: e['host'], id: e['id']),
          ),
        );
      });
    }
    print(ja);
  }

  @override
  Widget build(BuildContext context) {
    return _profiles?.isNotEmpty == true ? _buildList() : const SizedBox.shrink();
  }

  Widget _buildList() {
    return ListView(
      shrinkWrap: true,
      children: _profiles!
          .map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: ServerNodeItem(
                name: e.name,
                onServerItemClick: widget.onServerItemClick,
                isConnected: ref.watch(vpnProfileProvider)?.id == e.id,
                id: e.id,
              ),
            ),
          )
          .toList(),
    );
  }
}

class ServerNodeItem extends StatelessWidget {
  const ServerNodeItem({
    super.key,
    required this.name,
    required this.onServerItemClick,
    required this.isConnected,
    required this.id,
  });

  final String name;
  final OnServerItemClick onServerItemClick;
  final bool isConnected;
  final int id;

  @override
  Widget build(BuildContext context) {
    return SingleTapper(
      onTap: () => onServerItemClick(id),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        height: 62,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 56,
              child: Stack(
                children: [
                  Positioned(
                    left: 12,
                    top: 17,
                    child: Container(
                      height: 32,
                      width: 32,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(Assets.assetsImgsImgSmart),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 52,
                    bottom: 12,
                    child: Text(
                      name,
                      style: peaceSans,
                    ),
                  ),
                  Positioned(
                    right: 14,
                    bottom: 12,
                    child: Icon(isConnected ? Icons.check_circle_outline : Icons.radio_button_off),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
