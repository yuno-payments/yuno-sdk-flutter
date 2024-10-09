package com.example.example
import android.app.Application
import com.yuno_flutter.yuno_sdk_android.YunoSdkAndroidPlugin

class MyApp: Application() {
    override fun onCreate() {
        super.onCreate()
//        YunoSdkAndroidPlugin.initSdk(this, BuildConfig.YUNO_API_KEY)
        YunoSdkAndroidPlugin.initSdk(this, "staging_gAAAAABmfZ48j4sIsCGFlFxY5aipm0osWo8wfbwdTnGMX2RY-BnLPlUPlLSEyarnWan3ymzFz0zgw9HXYejiBzT10ihhCdKW3GpCOWCE2NR1d85Q0R6_pZ4NyCzvkGgrJFC1XMH987EHx15OtTq4OqPDZnGl0go5bGwdD1i3g1doYs_n-DUS2R2vCcCIf5fYceCvC7PrQLfWuLK5kAP5OL4IQBIAp6NagOzj9JRlkyxT_6SoxIAmwsPgcF-KOn-gpiLdu_OIwUOX")
    }
}