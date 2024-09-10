package com.example.yuno_sdk_android

import android.content.Context
import android.content.Intent
import com.yuno.payments.features.payment.startCheckout
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.example.yuno_sdk_android.core.utils.extensions.statusConverter
import com.example.yuno_sdk_android.core.utils.keys.Key
import com.example.yuno_sdk_android.features.app_config.method_channel.InitHandler
import com.example.yuno_sdk_android.features.start_payment_lite.method_channels.StartPaymentLiteHandler
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class YunoSdkAndroidPlugin :
    FlutterPlugin,
    MethodCallHandler,
    ActivityAware,
    DefaultLifecycleObserver {

    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var activity: FlutterFragmentActivity
    private lateinit var startActivityForResultLauncher: ActivityResultLauncher<Intent>


    override fun onCreate(owner: LifecycleOwner) {
        super.onCreate(owner)
        activity.startCheckout(
            checkoutSession = "",
            callbackPaymentState = this::onPaymentStateChange,
            callbackOTT = this::onTokenUpdated,

        )
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "yuno/payments")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            Key.init -> {
                val init = InitHandler()
                init.handler(
                    call = call,
                    result = result,
                    context = context
                )
            }
            "paymentMethods" -> {
            }
            Key.startPaymentLite -> {
                val startPaymentLiteHandler = StartPaymentLiteHandler()

                    startPaymentLiteHandler.handler(
                        call = call,
                        result = result,
                        context = context,
                        activity = activity
                    )


            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
            activity = binding.activity as FlutterFragmentActivity
            activity.lifecycle.addObserver(this)
            startActivityForResultLauncher = activity.registerForActivityResult(
                ActivityResultContracts.StartActivityForResult()
            ) { result ->
            }

    }

    override fun onDetachedFromActivity() {
        activity.lifecycle.removeObserver(this)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity as FlutterFragmentActivity
        activity.lifecycle.addObserver(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity.lifecycle.removeObserver(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    fun onTokenUpdated(token: String?) {
        channel.invokeMethod("ott", token)
    }

    fun onPaymentStateChange(paymentState: String?) {
       channel.invokeMethod("status", paymentState?.statusConverter())
    }
}