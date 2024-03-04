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

package com.access.vpn.core.sub

import androidx.recyclerview.widget.SortedList
import com.access.vpn.core.preference.DataStore
import com.access.vpn.core.utils.URLSorter
import com.access.vpn.core.utils.asIterable
import java.io.Reader
import java.net.URL

class Sub {
    companion object {
        private const val SUBSCRIPTION = "subscription"

        var instance: Sub
            get() {
                val sub = Sub()
                val str = DataStore.publicStore.getString(SUBSCRIPTION)
                if (str != null) sub.fromReader(str.reader())
                return sub
            }
            set(value) = DataStore.publicStore.putString(SUBSCRIPTION, value.toString())
    }

    val urls = SortedList(URL::class.java, URLSorter)

    fun fromReader(reader: Reader): Sub {
        urls.clear()
        reader.useLines {
            for (line in it) try {
                urls.add(URL(line))
            } catch (_: Exception) { }
        }
        return this
    }

    override fun toString(): String {
        val result = StringBuilder()
        result.append(urls.asIterable().joinToString("\n"))
        return result.toString()
    }
}
