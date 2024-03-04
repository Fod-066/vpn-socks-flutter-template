package com.access.vpn.core.aidl;

import com.access.vpn.core.aidl.TrafficStats;

oneway interface IAccessVpnServiceCallback {
  void stateChanged(int state, String profileName, String msg);
  void trafficUpdated(long profileId, in TrafficStats stats);
  // Traffic data has persisted to database, listener should refetch their data from database
  void trafficPersisted(long profileId);
}
