import 'dart:convert';

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
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
              child: ServerNodeItem(
                name: e.name,
                onServerItemClick: widget.onServerItemClick,
                isConnected: ref.watch(vpnProfileProvider)?.id == e.id,
                id: e.id,
                isLocked: _profiles!.indexOf(e) > 0,
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
    required this.isLocked,
  });

  final String name;
  final OnServerItemClick onServerItemClick;
  final bool isConnected;
  final int id;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return SingleTapper(
      onTap: () => onServerItemClick(id),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff17191e),
          borderRadius: BorderRadius.circular(31),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        height: 56,
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(Icons.share_location, color: isConnected ? const Color(0xffcef27e) : Colors.white),
              const SizedBox(width: 12),
              Text(
                name,
                style: peaceSans.copyWith(color: isConnected ? const Color(0xffcef27e) : Colors.white),
              ),
              if (isLocked)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                ),
              const Spacer(),
              Icon(
                Icons.chevron_right_rounded,
                color: isConnected ? const Color(0xffcef27e) : Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
