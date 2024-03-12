import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class VpnConnectTimeNotifier extends StateNotifier<int> {
  VpnConnectTimeNotifier() : super(0);

  Timer? timer;
  bool _isConnected = false;

  void init() {
    if (timer != null) return;
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_isConnected) {
          state = state + 1;
        }
      },
    );
  }

  void toggle(bool isConnected) {
    _isConnected = isConnected;
    if (_isConnected) {
      state = 0;
    }
  }
}

final vpnConnectTimeProvider = StateNotifierProvider<VpnConnectTimeNotifier, int>((ref) {
  return VpnConnectTimeNotifier();
});
