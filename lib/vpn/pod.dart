import 'package:drip_vpn/vpn/vpn_status.dart';
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

class VpnTraffic {
  final int txRate;
  final int rxRate;
  final int txTotal;
  final int rxTotal;

  VpnTraffic({required this.txRate, required this.rxRate, required this.txTotal, required this.rxTotal});

  factory VpnTraffic.zero() => VpnTraffic(txRate: 0, rxRate: 0, txTotal: 0, rxTotal: 0);

  static VpnTraffic from(dynamic json) {
    return VpnTraffic(
      txRate: json['txRate'] ?? 0,
      rxRate: json['rxRate'] ?? 0,
      txTotal: json['txTotal'] ?? 0,
      rxTotal: json['rxTotal'] ?? 0,
    );
  }
}

class VpnTrafficNotifier extends StateNotifier<VpnTraffic> {
  VpnTrafficNotifier() : super(VpnTraffic.zero());

  void change(VpnTraffic traffic) {
    state = traffic;
  }
}

final vpnTrafficPod = StateNotifierProvider<VpnTrafficNotifier, VpnTraffic>((ref) {
  return VpnTrafficNotifier();
});
