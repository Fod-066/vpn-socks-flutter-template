package com.access.vpn.core.aidl;

import com.access.vpn.core.aidl.IAccessVpnServiceCallback;

interface IAccessVpnService {
  int getState();
  String getProfileName();

  void registerCallback(in IAccessVpnServiceCallback cb);
  void startListeningForBandwidth(in IAccessVpnServiceCallback cb, long timeout);
  oneway void stopListeningForBandwidth(in IAccessVpnServiceCallback cb);
  oneway void unregisterCallback(in IAccessVpnServiceCallback cb);
}
