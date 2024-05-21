package com.drip.vpn.ui.plugin.bridge.channel

import com.drip.vpn.core.background.BaseService
import com.drip.vpn.core.background.BaseService.State.*
import com.drip.vpn.ui.status.VpnStatus

const val CALL_VPN_NATIVE_METHOD = "drip.vpn.native.method"
const val N2F_EVENT_CHANNEL = "drip.n2f.event.channel"

fun BaseService.State.status(): VpnStatus {
  return when (this) {
    Idle -> VpnStatus.Idle
    Connecting -> VpnStatus.Connecting
    Connected -> VpnStatus.Connected
    Stopping ->  VpnStatus.Stopping
    Stopped -> VpnStatus.Stopped
  }
}