plugins {
    id("com.android.library")
    id("com.vanniktech.maven.publish")
    kotlin("android")
    id("kotlin-parcelize")
    id("stringfog")
}


configure<com.github.megatronking.stringfog.plugin.StringFogExtension> {
    implementation = "com.github.megatronking.stringfog.xor.StringFogImpl"
    enable = true
    // fogPackages = arrayOf("com.xxx.xxx")
    kg = com.github.megatronking.stringfog.plugin.kg.RandomKeyGenerator()
//  mode = com.github.megatronking.stringfog.plugin.StringFogMode.bytes
}

setupCommon()

android {
    namespace = "com.access.vpn.plugin"
    lint.informational += "GradleDependency"
}

dependencies {
    api(kotlin("stdlib-jdk8"))
    api("androidx.core:core-ktx:1.7.0")
    api("androidx.fragment:fragment-ktx:1.5.5")
    api("com.google.android.material:material:1.6.0")
    api("com.github.megatronking.stringfog:xor:4.0.1")
}
