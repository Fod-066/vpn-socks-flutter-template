package com.sweet.vpn.core.plugin

object NoPlugin : Plugin() {
    override val id: String get() = ""
    override val label: CharSequence get() = "Disabled"
}
