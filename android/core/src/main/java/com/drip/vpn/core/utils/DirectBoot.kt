package com.drip.vpn.core.utils

import android.annotation.TargetApi
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import com.drip.vpn.core.Core
import com.drip.vpn.core.Core.app
import com.drip.vpn.core.background.BaseService
import com.drip.vpn.core.db.Profile
import com.drip.vpn.core.db.ProfileManager
import com.drip.vpn.core.preference.DataStore
import java.io.File
import java.io.IOException
import java.io.ObjectInputStream
import java.io.ObjectOutputStream

@TargetApi(24)
object DirectBoot : BroadcastReceiver() {
    private val file = File(com.drip.vpn.core.Core.deviceStorage.noBackupFilesDir, "directBootProfile")
    private var registered = false

    fun getDeviceProfile(): ProfileManager.ExpandedProfile? = try {
        ObjectInputStream(file.inputStream()).use { it.readObject() as? ProfileManager.ExpandedProfile }
    } catch (_: IOException) { null }

    fun clean() {
        file.delete()
        File(com.drip.vpn.core.Core.deviceStorage.noBackupFilesDir, BaseService.CONFIG_FILE).delete()
        File(com.drip.vpn.core.Core.deviceStorage.noBackupFilesDir, BaseService.CONFIG_FILE_UDP).delete()
    }

    /**
     * app.currentProfile will call this.
     */
    fun update(profile: Profile? = ProfileManager.getProfile(DataStore.profileId)) =
            if (profile == null) clean()
            else ObjectOutputStream(file.outputStream()).use { it.writeObject(ProfileManager.expand(profile)) }

    fun flushTrafficStats() {
        getDeviceProfile()?.also { (profile, fallback) ->
            if (profile.dirty) ProfileManager.updateProfile(profile)
            if (fallback?.dirty == true) ProfileManager.updateProfile(fallback)
        }
        update()
    }

    fun listenForUnlock() {
        if (registered) return
        app.registerReceiver(this, IntentFilter(Intent.ACTION_BOOT_COMPLETED))
        registered = true
    }
    override fun onReceive(context: Context, intent: Intent) {
        flushTrafficStats()
        app.unregisterReceiver(this)
        registered = false
    }
}
