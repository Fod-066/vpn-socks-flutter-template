/*******************************************************************************
 *                                                                             *
 *  Copyright (C) 2018 by Max Lv <max.c.lv@gmail.com>                          *
 *  Copyright (C) 2018 by Mygod Studio <contact-shadowsocks-android@mygod.be>  *
 *                                                                             *
 *  This program is free software: you can redistribute it and/or modify       *
 *  it under the terms of the GNU General Public License as published by       *
 *  the Free Software Foundation, either version 3 of the License, or          *
 *  (at your option) any later version.                                        *
 *                                                                             *
 *  This program is distributed in the hope that it will be useful,            *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of             *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *
 *  GNU General Public License for more details.                               *
 *                                                                             *
 *  You should have received a copy of the GNU General Public License          *
 *  along with this program. If not, see <http://www.gnu.org/licenses/>.       *
 *                                                                             *
 *******************************************************************************/

package com.drip.vpn.core

import android.app.*
import android.app.admin.DevicePolicyManager
import android.content.*
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.net.ConnectivityManager
import android.os.Build
import android.os.UserManager
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.annotation.VisibleForTesting
import androidx.core.content.ContextCompat
import androidx.core.content.getSystemService
import androidx.core.os.persistableBundleOf
import androidx.work.Configuration
import com.drip.vpn.core.acl.Acl
import com.drip.vpn.core.aidl.DripVpnConnection
import com.drip.vpn.core.db.Profile
import com.drip.vpn.core.db.ProfileManager
import com.drip.vpn.core.preference.DataStore
import com.drip.vpn.core.sub.SubService
import com.drip.vpn.core.utils.Action
import com.drip.vpn.core.utils.DeviceStorageApp
import com.drip.vpn.core.utils.DirectBoot
import com.drip.vpn.core.utils.Key
//import com.google.firebase.crashlytics.FirebaseCrashlytics
//import com.google.firebase.ktx.Firebase
//import com.google.firebase.ktx.initialize
import kotlinx.coroutines.DEBUG_PROPERTY_NAME
import kotlinx.coroutines.DEBUG_PROPERTY_VALUE_ON
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import timber.log.Timber
import java.io.File
import java.io.IOException
import kotlin.reflect.KClass

object Core : Configuration.Provider {
    lateinit var app: Application
        @VisibleForTesting set
    lateinit var configureIntent: (Context) -> PendingIntent
    val activity by lazy { com.drip.vpn.core.Core.app.getSystemService<ActivityManager>()!! }
    val clipboard by lazy { com.drip.vpn.core.Core.app.getSystemService<ClipboardManager>()!! }
    val connectivity by lazy { com.drip.vpn.core.Core.app.getSystemService<ConnectivityManager>()!! }
    val notification by lazy { com.drip.vpn.core.Core.app.getSystemService<NotificationManager>()!! }
    val user by lazy { com.drip.vpn.core.Core.app.getSystemService<UserManager>()!! }
    val packageInfo: PackageInfo by lazy { com.drip.vpn.core.Core.getPackageInfo(com.drip.vpn.core.Core.app.packageName) }
    val deviceStorage by lazy { if (Build.VERSION.SDK_INT < 24) com.drip.vpn.core.Core.app else DeviceStorageApp(
      com.drip.vpn.core.Core.app
    ) }
    val directBootSupported by lazy {
        Build.VERSION.SDK_INT >= 24 && try {
            com.drip.vpn.core.Core.app.getSystemService<DevicePolicyManager>()?.storageEncryptionStatus ==
                    DevicePolicyManager.ENCRYPTION_STATUS_ACTIVE_PER_USER
        } catch (_: RuntimeException) {
            false
        }
    }

    val activeProfileIds get() = ProfileManager.getProfile(DataStore.profileId).let {
        if (it == null) emptyList() else listOfNotNull(it.id, it.udpFallback)
    }
    val currentProfile: ProfileManager.ExpandedProfile? get() {
        if (DataStore.directBootAware) DirectBoot.getDeviceProfile()?.apply { return this }
        return ProfileManager.expand(ProfileManager.getProfile(DataStore.profileId) ?: return null)
    }

    fun switchProfile(id: Long): Profile {
        val result = ProfileManager.getProfile(id) ?: ProfileManager.createProfile()
        DataStore.profileId = result.id
        return result
    }

    fun init(app: Application, configureClass: KClass<out Any>) {
        com.drip.vpn.core.Core.app = app
        com.drip.vpn.core.Core.configureIntent = {
            PendingIntent.getActivity(it, 0, Intent(it, configureClass.java)
                    .setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT), PendingIntent.FLAG_IMMUTABLE)
        }

        if (Build.VERSION.SDK_INT >= 24) {  // migrate old files
            com.drip.vpn.core.Core.deviceStorage.moveDatabaseFrom(app, Key.DB_PUBLIC)
            val old = Acl.getFile(Acl.CUSTOM_RULES_USER, app)
            if (old.canRead()) {
                Acl.getFile(Acl.CUSTOM_RULES_USER).writeText(old.readText())
                old.delete()
            }
        }

        // overhead of debug mode is minimal: https://github.com/Kotlin/kotlinx.coroutines/blob/f528898/docs/debugging.md#debug-mode
        System.setProperty(DEBUG_PROPERTY_NAME, DEBUG_PROPERTY_VALUE_ON)
//        Firebase.initialize(deviceStorage)  // multiple processes needs manual set-up
        Timber.plant(object : Timber.DebugTree() {
            override fun log(priority: Int, tag: String?, message: String, t: Throwable?) {
                if (t == null) {
                    if (priority != Log.DEBUG || BuildConfig.DEBUG) Log.println(priority, tag, message)
//                    FirebaseCrashlytics.getInstance().log("${"XXVDIWEF".getOrElse(priority) { 'X' }}/$tag: $message")
                } else {
                    if (priority >= Log.WARN || priority == Log.DEBUG) Log.println(priority, tag, message)
//                    if (priority >= Log.INFO) FirebaseCrashlytics.getInstance().recordException(t)
                }
            }
        })

        // handle data restored/crash
        if (Build.VERSION.SDK_INT >= 24 && DataStore.directBootAware && com.drip.vpn.core.Core.user.isUserUnlocked) {
            DirectBoot.flushTrafficStats()
        }
        if (DataStore.publicStore.getLong(Key.assetUpdateTime, -1) != com.drip.vpn.core.Core.packageInfo.lastUpdateTime) {
            val assetManager = app.assets
            try {
                for (file in assetManager.list("acl")!!) assetManager.open("acl/$file").use { input ->
                    File(com.drip.vpn.core.Core.deviceStorage.noBackupFilesDir, file).outputStream().use { output -> input.copyTo(output) }
                }
            } catch (e: IOException) {
                Timber.w(e)
            }
            DataStore.publicStore.putLong(Key.assetUpdateTime, com.drip.vpn.core.Core.packageInfo.lastUpdateTime)
        }
      com.drip.vpn.core.Core.updateNotificationChannels()
    }

    override fun getWorkManagerConfiguration() = Configuration.Builder().apply {
        setDefaultProcessName(com.drip.vpn.core.Core.app.packageName + ":bg")
        setMinimumLoggingLevel(if (BuildConfig.DEBUG) Log.VERBOSE else Log.INFO)
        setExecutor { GlobalScope.launch { it.run() } }
        setTaskExecutor { GlobalScope.launch { it.run() } }
    }.build()

    fun updateNotificationChannels() {
        if (Build.VERSION.SDK_INT >= 26) @RequiresApi(26) {
            com.drip.vpn.core.Core.notification.createNotificationChannels(listOf(
                    NotificationChannel("service-vpn", "VPN Service",
                            if (Build.VERSION.SDK_INT >= 28) NotificationManager.IMPORTANCE_MIN
                            else NotificationManager.IMPORTANCE_LOW),   // #1355
                    NotificationChannel("service-proxy", "Proxy Service",
                            NotificationManager.IMPORTANCE_LOW),
                    NotificationChannel("service-transproxy", "Transproxy Service",
                            NotificationManager.IMPORTANCE_LOW),
                    SubService.notificationChannel))
            com.drip.vpn.core.Core.notification.deleteNotificationChannel("service-nat")   // NAT mode is gone for good
        }
    }

    fun getPackageInfo(packageName: String) = com.drip.vpn.core.Core.app.packageManager.getPackageInfo(packageName,
            if (Build.VERSION.SDK_INT >= 28) PackageManager.GET_SIGNING_CERTIFICATES
            else @Suppress("DEPRECATION") PackageManager.GET_SIGNATURES)!!

    fun trySetPrimaryClip(clip: String, isSensitive: Boolean = false) = try {
        com.drip.vpn.core.Core.clipboard.setPrimaryClip(ClipData.newPlainText(null, clip).apply {
            if (isSensitive && Build.VERSION.SDK_INT >= 24) {
                description.extras = persistableBundleOf(ClipDescription.EXTRA_IS_SENSITIVE to true)
            }
        })
        true
    } catch (e: RuntimeException) {
        Timber.d(e)
        false
    }

    fun startService() = ContextCompat.startForegroundService(com.drip.vpn.core.Core.app, Intent(com.drip.vpn.core.Core.app, DripVpnConnection.serviceClass))
    fun reloadService() = com.drip.vpn.core.Core.app.sendBroadcast(Intent(Action.RELOAD).setPackage(
      com.drip.vpn.core.Core.app.packageName))
    fun stopService() = com.drip.vpn.core.Core.app.sendBroadcast(Intent(Action.CLOSE).setPackage(com.drip.vpn.core.Core.app.packageName))
}
