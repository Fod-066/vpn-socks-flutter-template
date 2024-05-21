package com.sweet.vpn.ui.channel

import com.sweet.vpn.core.background.BaseService
import com.sweet.vpn.core.background.BaseService.State.*
import com.sweet.vpn.ui.status.VpnStatus

const val CALL_VPN_NATIVE_METHOD = "sweet.vpn.native.method"
const val EVENT_CHANNEL_VPN_STATUS = "sweet.vpn.status.channel"
const val EVENT_CHANNEL_PROFILE = "sweet.vpn.profile"

fun BaseService.State.status(): VpnStatus {
  return when (this) {
    Idle -> VpnStatus.Idle
    Connecting -> VpnStatus.Connecting
    Connected -> VpnStatus.Connected
    Stopping ->  VpnStatus.Stopping
    Stopped -> VpnStatus.Stopped
  }
}