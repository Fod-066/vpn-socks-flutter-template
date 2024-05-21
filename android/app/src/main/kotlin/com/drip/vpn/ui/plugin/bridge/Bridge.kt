package com.drip.vpn.ui.plugin.bridge

import androidx.annotation.UiThread
import com.drip.vpn.ui.plugin.bridge.channel.N2FEventChannelHandler
import com.drip.vpn.ui.plugin.bridge.channel.N2F_EVENT_CHANNEL
import com.drip.vpn.ui.plugin.bridge.event.Event
import com.google.gson.Gson
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel

object Bridge {
  private lateinit var eventChannel: EventChannel
  private lateinit var eventChannelHandler: N2FEventChannelHandler
  private var gson: Gson = Gson()

  @UiThread
  fun init(messenger: BinaryMessenger) {
    eventChannel = EventChannel(messenger, N2F_EVENT_CHANNEL)
    eventChannelHandler = N2FEventChannelHandler()
    eventChannel.setStreamHandler(eventChannelHandler)
  }

  @UiThread
  fun sendToFlutter(event: Event) {
    eventChannelHandler.send(gson.toJson(event))
  }
}