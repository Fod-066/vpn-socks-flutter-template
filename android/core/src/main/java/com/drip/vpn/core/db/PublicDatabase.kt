/*******************************************************************************
 *                                                                             *
 *  Copyright (C) 2017 by Max Lv <max.c.lv@gmail.com>                          *
 *  Copyright (C) 2017 by Mygod Studio <contact-shadowsocks-android@mygod.be>  *
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

package com.drip.vpn.core.db

import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import com.drip.vpn.core.Core
import com.drip.vpn.core.db.migration.RecreateSchemaMigration
import com.drip.vpn.core.utils.Key
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

@Database(entities = [KeyValuePair::class], version = 3)
abstract class PublicDatabase : RoomDatabase() {
    companion object {
        private val instance by lazy {
            Room.databaseBuilder(com.drip.vpn.core.Core.deviceStorage, PublicDatabase::class.java, Key.DB_PUBLIC).apply {
                addMigrations(
                        Migration3
                )
                allowMainThreadQueries()
                enableMultiInstanceInvalidation()
                fallbackToDestructiveMigration()
                setQueryExecutor { GlobalScope.launch { it.run() } }
            }.build()
        }

        val kvPairDao get() = instance.keyValuePairDao()
    }
    abstract fun keyValuePairDao(): KeyValuePair.Dao

    internal object Migration3 : RecreateSchemaMigration(2, 3, "KeyValuePair",
            "(`key` TEXT NOT NULL, `valueType` INTEGER NOT NULL, `value` BLOB NOT NULL, PRIMARY KEY(`key`))",
            "`key`, `valueType`, `value`")
}
