package com.drip.vpn.core.aidl;

import com.drip.vpn.core.aidl.IDripVpnServiceCallback;

interface IDripVpnService {
  int getState();
  String getProfileName();

  void registerCallback(in IDripVpnServiceCallback cb);
  void startListeningForBandwidth(in IDripVpnServiceCallback cb, long timeout);
  oneway void stopListeningForBandwidth(in IDripVpnServiceCallback cb);
  oneway void unregisterCallback(in IDripVpnServiceCallback cb);
}
