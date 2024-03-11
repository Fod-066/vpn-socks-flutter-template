import 'package:sweet_vpn/vpn/vpn_status.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VpnStatusNotifier extends StateNotifier<VpnStatus> {
  VpnStatusNotifier() : super(VpnStatus.idle);

  void change(VpnStatus newStatus) {
    if (state != newStatus) {
      state = newStatus;
    }
  }
}

final vpnStatusPod = StateNotifierProvider<VpnStatusNotifier, VpnStatus>((ref) {
  return VpnStatusNotifier();
});
