package com.sweet.vpn.ui.channel

import io.flutter.plugin.common.EventChannel

class ProfileEventChannelHandler :EventChannel.StreamHandler {

  private var eventSink: EventChannel.EventSink? = null
  override fun onListen(
    arguments: Any?,
    events: EventChannel.EventSink?,
  ) {
    this.eventSink = events
  }

  override fun onCancel(arguments: Any?) {
  }

  fun send(event: String?) {
    eventSink?.success(event)
  }
}