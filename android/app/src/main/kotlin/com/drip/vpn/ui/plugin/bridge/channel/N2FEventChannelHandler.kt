package com.drip.vpn.ui.plugin.bridge.channel

import androidx.annotation.UiThread
import com.drip.vpn.ui.utils.Logger
import com.google.gson.Gson
import com.we.sv.event.EventConvert
import com.we.sv.logger.Logger
import io.flutter.plugin.common.EventChannel
import kotlin.math.sin

class N2FEventChannelHandler : EventChannel.StreamHandler {

  private var sink: EventChannel.EventSink? = null

  private val gson = Gson()

  private val omissionEvents = mutableListOf<Any>()

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
  fun send(any: Any) {
    var msg = gson.toJson(any)
    Logger.d("EVENT", "send $msg ${sink == null}")
    if (sink == null) {
      omissionEvents.add(any)
    } else {
      sink?.success(msg)
    }
  }
}