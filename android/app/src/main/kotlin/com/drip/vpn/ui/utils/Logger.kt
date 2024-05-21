package com.drip.vpn.ui.utils

import timber.log.Timber

object Logger {
  fun d(tag: String, msg: String) {
    Timber.tag(tag).d(msg)
  }
}