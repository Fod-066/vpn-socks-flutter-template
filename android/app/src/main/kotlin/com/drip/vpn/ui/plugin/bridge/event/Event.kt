package com.drip.vpn.ui.plugin.bridge.event

import androidx.annotation.Keep
import com.drip.vpn.core.db.Profile
import com.drip.vpn.ui.status.VpnStatus
import com.google.gson.annotations.Expose


@Keep
sealed class Event(val name: String, val data: Any? = null) {

  @Keep
  class VpnStateEvent(
    @Transient
    val vpnStatus: VpnStatus
  ) :
    Event(name = "vpn_state_event", data = vpnStatus.state)

  @Keep
  class ProfileEvent(
    @Transient
    val profile: Profile?
  ) : Event(name = "profile_event", data = profile)

}


