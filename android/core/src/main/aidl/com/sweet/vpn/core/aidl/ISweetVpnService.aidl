package com.sweet.vpn.core.aidl;

import com.sweet.vpn.core.aidl.IAccessVpnServiceCallback;

interface IAccessVpnService {
  int getState();
  String getProfileName();

  void registerCallback(in IAccessVpnServiceCallback cb);
  void startListeningForBandwidth(in IAccessVpnServiceCallback cb, long timeout);
  oneway void stopListeningForBandwidth(in IAccessVpnServiceCallback cb);
  oneway void unregisterCallback(in IAccessVpnServiceCallback cb);
}
