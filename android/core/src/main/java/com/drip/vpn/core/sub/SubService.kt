/*******************************************************************************
 *                                                                             *
 *  Copyright (C) 2020 by Max Lv <max.c.lv@gmail.com>                          *
 *  Copyright (C) 2020 by Mygod Studio <contact-shadowsocks-android@mygod.be>  *
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

package com.drip.vpn.core.sub

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.content.IntentFilter
import android.graphics.Color
import android.os.IBinder
import android.widget.Toast
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import androidx.lifecycle.MutableLiveData
import com.drip.vpn.core.Core
import com.drip.vpn.core.db.Profile
import com.drip.vpn.core.db.ProfileManager
import com.drip.vpn.core.preference.DataStore
import com.drip.vpn.core.utils.*
import com.google.gson.JsonStreamParser
import com.drip.vpn.core.utils.Action
import com.drip.vpn.core.utils.asIterable
import com.drip.vpn.core.utils.broadcastReceiver
import com.drip.vpn.core.utils.readableMessage
import com.drip.vpn.core.utils.useCancellable
import kotlinx.coroutines.*
import timber.log.Timber
import java.io.File
import java.io.InputStream
import java.net.HttpURLConnection
import java.net.URL

class SubService : Service(), CoroutineScope {
    companion object {
        private const val NOTIFICATION_CHANNEL = "service-subscription"
        private const val NOTIFICATION_ID = 2

        val idle = MutableLiveData(true)

        val notificationChannel @RequiresApi(26) get() = NotificationChannel(
          NOTIFICATION_CHANNEL,
            "Subscription Service", NotificationManager.IMPORTANCE_LOW)
    }

    override val coroutineContext = SupervisorJob() + CoroutineExceptionHandler { _, t -> Timber.w(t) }
    private var worker: Job? = null
    private val cancelReceiver = broadcastReceiver { _, _ -> worker?.cancel() }
    private var counter = 0
    private var receiverRegistered = false

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (worker == null) {
            idle.value = false
            if (!receiverRegistered) {
                ContextCompat.registerReceiver(this, cancelReceiver, IntentFilter(Action.ABORT),
                    ContextCompat.RECEIVER_NOT_EXPORTED)
                receiverRegistered = true
            }
            worker = launch {
                val urls = Sub.instance.urls
                val notification = NotificationCompat.Builder(this@SubService, NOTIFICATION_CHANNEL).apply {
                    color = Color.BLACK
                    priority = NotificationCompat.PRIORITY_LOW
                    addAction(NotificationCompat.Action.Builder(
                            com.drip.vpn.plugin.R.drawable.ic_navigation_close,
                            "Stop",
                            PendingIntent.getBroadcast(this@SubService, 0,
                                    Intent(Action.ABORT).setPackage(packageName), PendingIntent.FLAG_IMMUTABLE)).apply {
                        setShowsUserInterface(false)
                    }.build())
                    setCategory(NotificationCompat.CATEGORY_PROGRESS)
                    setContentTitle("Syncing...")
                    setOngoing(true)
                    setProgress(urls.size(), 0, false)
//                    setSmallIcon(R.drawable.ic_file_cloud_download)
                    setWhen(0)
                }
                com.drip.vpn.core.Core.notification.notify(NOTIFICATION_ID, notification.build())
                counter = 0
                val workers = urls.asIterable().map { url -> fetchJsonAsync(url, urls.size(), notification) }
                try {
                    val localJsons = workers.awaitAll()
                    withContext(Dispatchers.Main) {
                        com.drip.vpn.core.Core.notification.notify(NOTIFICATION_ID, notification.apply {
                            setContentTitle("Finishing up…")
                            setProgress(0, 0, true)
                        }.build())
                        createProfilesFromSubscription(localJsons.asSequence().filterNotNull().map { it.inputStream() })
                    }
                } finally {
                    for (worker in workers) {
                        worker.cancel()
                        try {
                            worker.getCompleted()?.apply { if (!delete()) deleteOnExit() }
                        } catch (_: Exception) { }
                    }
                    GlobalScope.launch(Dispatchers.Main) {
                        com.drip.vpn.core.Core.notification.cancel(NOTIFICATION_ID)
                        idle.value = true
                    }
                    check(worker != null)
                    worker = null
                    stopSelf(startId)
                }
            }
        } else stopSelf(startId)
        return START_NOT_STICKY
    }

    private fun fetchJsonAsync(url: URL, max: Int, notification: NotificationCompat.Builder) = async(Dispatchers.IO) {
        val tempFile = File.createTempFile("subscription-", ".json", cacheDir)
        try {
            (url.openConnection() as HttpURLConnection).useCancellable {
                tempFile.outputStream().use { out -> inputStream.copyTo(out) }
            }
            tempFile
        } catch (e: Exception) {
            Timber.d(e)
            launch(Dispatchers.Main) {
                Toast.makeText(this@SubService, e.readableMessage, Toast.LENGTH_LONG).show()
            }
            if (!tempFile.delete()) tempFile.deleteOnExit()
            null
        } finally {
            withContext(Dispatchers.Main) {
                counter += 1
                com.drip.vpn.core.Core.notification.notify(NOTIFICATION_ID, notification.apply {
                    setContentTitle("Syncing...")
                    setProgress(max, counter, false)
                }.build())
            }
        }
    }

    private fun createProfilesFromSubscription(jsons: Sequence<InputStream>) {
        val currentId = DataStore.profileId
        val profiles = ProfileManager.getAllProfiles()
        val subscriptions = mutableMapOf<Pair<String?, String>, Profile>()
        val toUpdate = mutableSetOf<Long>()
        var feature: Profile? = null
        profiles?.forEach { profile ->  // preprocessing phase
            if (currentId == profile.id) feature = profile
            if (profile.subscription == Profile.SubscriptionStatus.UserConfigured) return@forEach
            if (subscriptions.putIfAbsent(profile.name to profile.formattedAddress, profile) != null) {
                ProfileManager.delProfile(profile.id)
                if (currentId == profile.id) DataStore.profileId = 0
            } else if (profile.subscription == Profile.SubscriptionStatus.Active) {
                toUpdate.add(profile.id)
                profile.subscription = Profile.SubscriptionStatus.Obsolete
            }
        }

        for (json in jsons.asIterable()) try {
            Profile.parseJson(JsonStreamParser(json.bufferedReader()).asSequence().single(), feature) {
                subscriptions.compute(it.name to it.formattedAddress) { _, oldProfile ->
                    when (oldProfile?.subscription) {
                        Profile.SubscriptionStatus.Active -> {
                            Timber.w("Duplicate profiles detected. Please use different profile names and/or " +
                                    "address:port for better subscription support.")
                            oldProfile
                        }
                        Profile.SubscriptionStatus.Obsolete -> {
                            toUpdate.add(oldProfile.id)
                            oldProfile.password = it.password
                            oldProfile.method = it.method
                            oldProfile.plugin = it.plugin
                            oldProfile.udpFallback = it.udpFallback
                            oldProfile.subscription = Profile.SubscriptionStatus.Active
                            oldProfile
                        }
                        else -> ProfileManager.createProfile(it.apply {
                            subscription = Profile.SubscriptionStatus.Active
                        })
                    }
                }!!
            }
        } catch (e: Exception) {
            Timber.d(e)
            Toast.makeText(this, e.readableMessage, Toast.LENGTH_LONG).show()
        }

        profiles?.forEach { profile -> if (toUpdate.contains(profile.id)) ProfileManager.updateProfile(profile) }
        ProfileManager.listener?.reloadProfiles()
    }

    override fun onDestroy() {
        cancel()
        if (receiverRegistered) unregisterReceiver(cancelReceiver)
        super.onDestroy()
    }
}
