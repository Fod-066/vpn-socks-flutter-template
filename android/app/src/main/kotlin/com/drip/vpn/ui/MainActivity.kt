package com.drip.vpn.ui

import android.content.Intent
import android.net.Uri
import android.net.VpnService
import android.os.Bundle
import androidx.lifecycle.lifecycleScope
import com.drip.vpn.core.Core
import com.drip.vpn.core.aidl.DripVpnConnection
import com.drip.vpn.core.aidl.IDripVpnService
import io.flutter.embedding.android.FlutterActivity
import timber.log.Timber
import com.drip.vpn.core.background.BaseService.State.*
import com.drip.vpn.core.background.BaseService.State
import com.drip.vpn.core.db.Profile
import com.drip.vpn.core.db.ProfileManager
import com.drip.vpn.ui.channel.CALL_VPN_NATIVE_METHOD
import com.drip.vpn.ui.channel.EVENT_CHANNEL_PROFILE
import com.drip.vpn.ui.channel.EVENT_CHANNEL_VPN_STATUS
import com.drip.vpn.ui.channel.ProfileEventChannelHandler
import com.drip.vpn.ui.channel.VpnStatusEventChannelHandler
import com.drip.vpn.ui.channel.status
import com.drip.vpn.ui.status.VpnStatus
import com.google.gson.Gson
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.util.concurrent.atomic.AtomicBoolean

class MainActivity : FlutterActivity(), DripVpnConnection.Callback {

  private val connection = DripVpnConnection(true)
  private var currentVpnState = Idle
  private var currentVpnStatus = VpnStatus.Idle
  private val isInitVpnCalled = AtomicBoolean(false)
  private val profiles = mutableListOf<Profile>()
  private lateinit var vpnStatusEC: EventChannel
  private lateinit var profileEC: EventChannel
  private lateinit var vpnStatusECHandler: VpnStatusEventChannelHandler
  private lateinit var profileECHandler: ProfileEventChannelHandler
  private var lastConnectionIsSwitching = false

  override fun onCreate(savedInstanceState: Bundle?) {
    initVpn()
    super.onCreate(savedInstanceState)
  }

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    bindNativeMethod(flutterEngine)
    bindEventChannels(flutterEngine)
  }

  private fun bindNativeMethod(flutterEngine: FlutterEngine) {
    MethodChannel(
      flutterEngine.dartExecutor.binaryMessenger,
      CALL_VPN_NATIVE_METHOD
    ).setMethodCallHandler { call, result ->
      log("flutter call native method:${call.method}")
      when (call.method) {
        "toggle" -> {
          toggle()
        }

        "getAllProfiles" -> {
          result.success(getAllProfiles())
        }

        "switch" -> {
          (call.arguments as Int?)?.let {
            switch(it.toLong())
          } ?: kotlin.run {
            switch(profiles.random().id)
          }
        }

        "openGp" -> {
          openGp()
        }

        "openBrowser" -> {
          openBrowser()
        }

        "start" -> {
          startVpn()
        }

        "stop" -> {
          Core.stopService()
        }
      }
    }
  }

  private fun bindEventChannels(flutterEngine: FlutterEngine) {
    vpnStatusEC = EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL_VPN_STATUS)
    profileEC = EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL_PROFILE)
    vpnStatusECHandler = VpnStatusEventChannelHandler()
    vpnStatusEC.setStreamHandler(vpnStatusECHandler)
    profileECHandler = ProfileEventChannelHandler()
    profileEC.setStreamHandler(profileECHandler)
  }

  private fun initVpn() {
    if (isInitVpnCalled.get()) return
    Core.init(application, MainActivity::class)
    connection.connect(this, this)
    ProfileManager.clear()
    val p = ProfileManager.createProfile(
      Profile(
        name = "Montreal",
        host = "51.79.69.99",
        remotePort = 5131,
        password = "mEaySpF1IKrfzZge",
        method = "chacha20-ietf-poly1305"
      )
    )
    val p1 = ProfileManager.createProfile(
      Profile(
        name = "Phoenix",
        host = "51.79.69.99",
        remotePort = 5131,
        password = "mEaySpF1IKrfzZge",
        method = "chacha20-ietf-poly1305"
      )
    )
    val p2 = ProfileManager.createProfile(
      Profile(
        name = "Dover",
        host = "51.79.69.99",
        remotePort = 5131,
        password = "mEaySpF1IKrfzZge",
        method = "chacha20-ietf-poly1305"
      )
    )
    val p3 = ProfileManager.createProfile(
      Profile(
        name = "Reno",
        host = "51.79.69.99",
        remotePort = 5131,
        password = "mEaySpF1IKrfzZge",
        method = "chacha20-ietf-poly1305"
      )
    )
    profiles.add(p)
    profiles.add(p1)
    profiles.add(p2)
    profiles.add(p3)
    Core.switchProfile(p.id)
    log("vpn init finish")
    isInitVpnCalled.set(true)
  }

  private fun getAllProfiles(): String {
    return Gson().toJson(profiles)
  }

  private fun toggle() {
    val isAllowedVpnPermission = isVpnServicePermissionGranted()
    if (isAllowedVpnPermission) {
      if (currentVpnState.canStop) {
        stopVpn()
      } else {
        startVpn()
      }
    } else {
      requestVpnServicePermission()
    }
  }

  private fun startVpn(isSwitchProfile: Boolean = false) {
    log("start vpn")
    lifecycleScope.launch {
      vpnStatusECHandler.send(if (isSwitchProfile) VpnStatus.Switching.state else VpnStatus.Connecting.state)
      lastConnectionIsSwitching = isSwitchProfile
      if (isSwitchProfile) {
        currentVpnStatus = VpnStatus.Switching
        Core.stopService()
      }
      delay(2000L)
      Core.startService()
    }
  }

  private fun stopVpn() {
    log("stop vpn")
    lifecycleScope.launch {
      vpnStatusECHandler.send(VpnStatus.Stopping.state)
//      delay(2000L)
//      Core.stopService()
    }
  }

  private fun switch(id: Long) {
    log("switch vpn $id")
    Core.switchProfile(id)
    startVpn(true)
  }

  private val VPN_PERMISSION_REQUEST_CODE = 1234

  private fun isVpnServicePermissionGranted(): Boolean {
    try {
      val vpnService = VpnService.prepare(applicationContext)
      return vpnService == null
    } catch (e: SecurityException) {
    }
    return false
  }

  private fun requestVpnServicePermission() {
    val vpnPermissionIntent = VpnService.prepare(applicationContext)
    if (vpnPermissionIntent != null) {
      startActivityForResult(vpnPermissionIntent, VPN_PERMISSION_REQUEST_CODE)
    } else {
      onActivityResult(VPN_PERMISSION_REQUEST_CODE, RESULT_OK, null)
    }
  }

  override fun onActivityResult(
    requestCode: Int,
    resultCode: Int,
    data: Intent?,
  ) {
    if (requestCode == VPN_PERMISSION_REQUEST_CODE) {
      if (resultCode == RESULT_OK) {
        startVpn()
      }
    } else {
      super.onActivityResult(requestCode, resultCode, data)
    }
  }

  override fun stateChanged(state: State, profileName: String?, msg: String?) {
    log("VPN,stageChanged:$state $currentVpnStatus")
    currentVpnState = state
    if (currentVpnStatus == VpnStatus.Switching && (currentVpnState == Stopping || currentVpnState == Stopped || currentVpnState == Connecting)) {

      return
    }
    currentVpnStatus = currentVpnState.status()
    vpnStatusECHandler.send(currentVpnStatus.state)
    profileECHandler.send(if (currentVpnState == Connected) Gson().toJson(Core.currentProfile?.main) else null)
    log("VPN,send:$currentVpnStatus ${Core.currentProfile?.main?.name}")
  }

  override fun onBinderDied() {
    super.onBinderDied()
    connection.disconnect(this)
    connection.connect(this, this)
  }

  override fun onServiceConnected(service: IDripVpnService) {
    val state = try {
      State.values()[service.state]
    } catch (e: Exception) {
      Idle
    }
    currentVpnState = state
    log("onServiceConnected,$currentVpnState")
//    eventHandler.send(state.statusStr(false))
  }

  override fun onStart() {
    connection.bandwidthTimeout = 500L
    super.onStart()
  }

  override fun onStop() {
    connection.bandwidthTimeout = 0L
    super.onStop()
  }

  override fun onDestroy() {
    Core.stopService()
    connection.disconnect(this)
    super.onDestroy()
  }

  private fun log(msg: String) {
    Timber.tag("DripVpn").d(msg)
  }

  private fun openGp() {
    val pkgName = ""
    val uri = Uri.parse("https://play.google.com/store/apps/developer?id=$pkgName")
    val intent = Intent(Intent.ACTION_VIEW, uri)
    intent.setPackage("com.android.vending")
    startActivity(intent)
  }

  private fun openBrowser() {
    val intent = Intent(Intent.ACTION_VIEW)
    intent.data = Uri.parse("https://google.com")
    startActivity(intent)
  }
}
