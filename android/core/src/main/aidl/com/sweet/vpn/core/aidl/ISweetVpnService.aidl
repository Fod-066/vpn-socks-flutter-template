package com.sweet.vpn.core.aidl;

import com.sweet.vpn.core.aidl.ISweetVpnServiceCallback;

interface ISweetVpnService {
  int getState();
  String getProfileName();

  void registerCallback(in ISweetVpnServiceCallback cb);
  void startListeningForBandwidth(in ISweetVpnServiceCallback cb, long timeout);
  oneway void stopListeningForBandwidth(in ISweetVpnServiceCallback cb);
  oneway void unregisterCallback(in ISweetVpnServiceCallback cb);
}
