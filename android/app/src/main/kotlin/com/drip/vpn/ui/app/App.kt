package com.sweet.vpn.ui.app

import com.sweet.vpn.core.Core
import com.sweet.vpn.ui.MainActivity
import io.flutter.app.FlutterApplication

class App : FlutterApplication() {
  override fun onCreate() {
    super.onCreate()
    Core.init(this, MainActivity::class)
  }
}