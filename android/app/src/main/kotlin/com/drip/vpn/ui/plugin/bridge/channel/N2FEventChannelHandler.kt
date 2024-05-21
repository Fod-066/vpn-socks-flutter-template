package com.drip.vpn.ui.plugin.bridge.channel

import androidx.annotation.UiThread
import com.drip.vpn.ui.utils.Logger
import com.google.gson.Gson
import io.flutter.plugin.common.EventChannel

class N2FEventChannelHandler : EventChannel.StreamHandler {

  private var sink: EventChannel.EventSink? = null

  private val gson = Gson()

  private val omissionEvents = mutableListOf<String>()

  override fun onListen(
    arguments: Any?,
    events: EventChannel.EventSink?,
  ) {
    Logger.d("EVENT", "sink bind finish")
    sink = events
    if (omissionEvents.isNotEmpty()) {
      omissionEvents.forEach {
        sink?.success(gson.toJson(it))
      }
      omissionEvents.clear()
    }
  }

  override fun onCancel(arguments: Any?) {
  }

  @UiThread
  fun send(event: String) {
    Logger.d("EVENT", "send $event ${sink == null}")
    if (sink == null) {
      omissionEvents.add(event)
    } else {
      sink?.success(event)
    }
  }
}