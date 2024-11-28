package com.example.example
import android.app.Application
import com.yuno_flutter.yuno_sdk_android.YunoSdkAndroidPlugin

class MyApp : Application() {
    override fun onCreate() {
        super.onCreate()
        YunoSdkAndroidPlugin.initSdk(this, BuildConfig.YUNO_API_KEY)
    }
}