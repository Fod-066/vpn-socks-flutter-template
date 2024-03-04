package com.access.vpn.ui.channel

import com.access.vpn.core.background.BaseService
import com.access.vpn.core.background.BaseService.State.*
import com.access.vpn.ui.status.VpnStatus

const val CALL_VPN_NATIVE_METHOD = "access.vpn.native.method"
const val EVENT_CHANNEL_VPN_STATUS = "access.vpn.status.channel"
const val EVENT_CHANNEL_PROFILE = "access.vpn.profile"

fun BaseService.State.status(): VpnStatus {
  return when (this) {
    Idle -> VpnStatus.Idle
    Connecting -> VpnStatus.Connecting
    Connected -> VpnStatus.Connected
    Stopping ->  VpnStatus.Stopping
    Stopped -> VpnStatus.Stopped
  }
}