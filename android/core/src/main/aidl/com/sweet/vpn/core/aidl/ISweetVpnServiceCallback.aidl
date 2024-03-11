package com.sweet.vpn.core.aidl;

import com.sweet.vpn.core.aidl.TrafficStats;

oneway interface ISweetVpnServiceCallback {
  void stateChanged(int state, String profileName, String msg);
  void trafficUpdated(long profileId, in TrafficStats stats);
  // Traffic data has persisted to database, listener should refetch their data from database
  void trafficPersisted(long profileId);
}
