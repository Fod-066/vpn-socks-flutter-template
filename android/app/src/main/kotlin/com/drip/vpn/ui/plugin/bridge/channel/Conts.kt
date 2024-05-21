package com.drip.vpn.ui.channel

import com.drip.vpn.core.background.BaseService
import com.drip.vpn.core.background.BaseService.State.*
import com.drip.vpn.ui.status.VpnStatus

const val CALL_VPN_NATIVE_METHOD = "drip.vpn.native.method"
const val EVENT_CHANNEL_VPN_STATUS = "drip.vpn.status.channel"
const val EVENT_CHANNEL_PROFILE = "drip.vpn.profile"

fun BaseService.State.status(): VpnStatus {
  return when (this) {
    Idle -> VpnStatus.Idle
    Connecting -> VpnStatus.Connecting
    Connected -> VpnStatus.Connected
    Stopping ->  VpnStatus.Stopping
    Stopped -> VpnStatus.Stopped
  }
}