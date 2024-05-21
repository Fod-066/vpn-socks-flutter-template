package com.drip.vpn.ui.app

import com.drip.vpn.core.Core
import com.drip.vpn.ui.MainActivity
import io.flutter.app.FlutterApplication

class App : FlutterApplication() {
  override fun onCreate() {
    super.onCreate()
    com.drip.vpn.core.Core.init(this, MainActivity::class)
  }
}