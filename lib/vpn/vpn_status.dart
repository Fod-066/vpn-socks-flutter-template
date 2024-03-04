enum VpnStatus {
  idle,
  connecting,
  connected,
  switching,
  stopping,
  stopped,
}

extension VpnStatusExt on VpnStatus {
  bool get isExecuting =>
      this == VpnStatus.stopping || this == VpnStatus.connecting;
}