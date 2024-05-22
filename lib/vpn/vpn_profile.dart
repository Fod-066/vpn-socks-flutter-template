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
      var profile = VpnProfile(name: data['name'], host: data['host'], id: data['id']);
      state = profile;
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
