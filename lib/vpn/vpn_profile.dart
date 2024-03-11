import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class VpnProfile {
  final String name;
  final String host;
  final int id;

  const VpnProfile({required this.name, required this.host, required this.id});
}

class VpnProfileNotifier extends StateNotifier<VpnProfile?> {
  VpnProfileNotifier() : super(null);

  void change(dynamic data) {
    if (null == data) {
      state = null;
    } else {
      if (data is String) {
        var json = jsonDecode(data);
        if (json != null) {
          var profile = VpnProfile(name: json['name'], host: json['host'], id: json['id']);
          state = profile;
        }
      }
    }
  }
}

final vpnProfileProvider = StateNotifierProvider<VpnProfileNotifier, VpnProfile?>((ref) {
  return VpnProfileNotifier();
});

class VpnProfilesNotifier extends StateNotifier<List<VpnProfile>> {
  VpnProfilesNotifier() : super(List.empty());

  void change(List<VpnProfile> profiles) {
    if (state != profiles) {
      state = profiles;
    }
  }
}

final vpnProfilesProvider = StateNotifierProvider<VpnProfilesNotifier, List<VpnProfile>>((ref) {
  return VpnProfilesNotifier();
});
