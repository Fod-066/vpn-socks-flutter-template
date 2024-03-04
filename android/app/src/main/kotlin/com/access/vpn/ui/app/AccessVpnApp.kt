package com.access.vpn.ui.app

import com.access.vpn.core.Core
import com.access.vpn.ui.MainActivity
import io.flutter.app.FlutterApplication

class AccessVpnApp : FlutterApplication() {
  override fun onCreate() {
    super.onCreate()
    Core.init(this, MainActivity::class)
  }
}