package com.drip.vpn.ui.channel

import io.flutter.plugin.common.EventChannel

class VpnStatusEventChannelHandler: EventChannel.StreamHandler {

  private var sink: EventChannel.EventSink? = null
  override fun onListen(
    arguments: Any?,
    events: EventChannel.EventSink?,
  ) {
    sink = events
  }

  override fun onCancel(arguments: Any?) {
  }

  fun send(profile: String?) {
    sink?.success(profile)
  }
}