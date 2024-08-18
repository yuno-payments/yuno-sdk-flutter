package com.example.yuno_sdk_android

import android.content.Context
import android.content.Intent
import android.util.Log
import com.yuno.payments.core.Yuno
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
import com.example.yuno_sdk_android.models.toApiConfig
import com.yuno.payments.core.YunoConfig
import com.yuno.payments.features.payment.startPaymentLite
import com.yuno.payments.features.payment.ui.views.PaymentSelected
import com.yuno.payments.features.payment.updateCheckoutSession
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
            "initialize" -> {
                try {
                    val argument = call.arguments<Map<String, Any>>()
                    val resultConverter = argument?.toApiConfig()

                    resultConverter?.onSuccess { appConfig ->
                        val config = appConfig.configuration;
                        if (appConfig.apiKey.isEmpty()) {
                            return result.error(
                                "4",
                                "ApiKey is empty",
                                "ApiKey must be necessary for starting to use Yuno SDK"
                            )
                        }
                        Yuno.initialize(
                            context,
                            appConfig.apiKey,
                            config = YunoConfig(
                                saveCardEnabled = config.saveCardEnable,
                                cardFormDeployed = config.cardFormDeployed,
                                isDynamicViewEnabled = config.isDynamicViewEnable,
                                keepLoader = config.keepLoader,
                            )
                        )
                        return result.success(true)
                    }?.onFailure { exception ->
                        println()
                        return result.error(
                            "5",
                            "Failure: An error occurred - ${exception.message}",
                            "Invalid arguments in json cast"
                        )

                    }

                } catch (e: Exception) {
                    return result.error("SOMETHING_WENT_WRONG", "Failure", e.message)
                }
            }

            "paymentMethods" -> {
                
//        try {
//          val intent = Intent(activity, PaymentMethodsActivity::class.java)
//
//          startActivityForResultLauncher.launch(intent)
//          result.success(true)
//        } catch (e: Exception) {
//          println("${e}")
//        }
            }

            "startPayment" -> {
                try {
                    activity.startPaymentLite(
                        paymentSelected = PaymentSelected(
                            paymentMethodType = "CARD",
                            vaultedToken = ""
                        )
                    )
                    result.success(true)
                } catch (e: Exception) {
                    println("${e}")
                }
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
            // Handle the result of the launched activity
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
        token?.let {
            println("${token}")
            Log.e("Payment flow", "success ---> token: $token")
        }
    }

    fun onPaymentStateChange(paymentState: String?) {
        paymentState?.let {
            print("${paymentState}")
        }


    }
}