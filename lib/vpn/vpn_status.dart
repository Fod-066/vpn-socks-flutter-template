enum VpnStatus {
  idle,
  connecting,
  connected,
  switching,
  stopping,
  stopped,
}

extension VpnStatusExt on VpnStatus {
  bool get isExecuting => this == VpnStatus.stopping || this == VpnStatus.connecting || this == VpnStatus.switching;

  bool get isNeddShowExecuting => this == VpnStatus.connecting || this == VpnStatus.stopping;

  bool get isConnecting => this == VpnStatus.connecting || this == VpnStatus.switching;

  bool get isConnetced => this == VpnStatus.connected;
}
