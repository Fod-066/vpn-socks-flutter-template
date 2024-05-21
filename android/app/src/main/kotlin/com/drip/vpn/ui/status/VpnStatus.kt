package com.drip.vpn.ui.status

enum class VpnStatus(val state: String) {
  Connected("connected"),
  Connecting("connecting"),
  Switching("switching"),
  Stopped("stopped"),
  Stopping("stopping"),
  Idle("idle"),
}