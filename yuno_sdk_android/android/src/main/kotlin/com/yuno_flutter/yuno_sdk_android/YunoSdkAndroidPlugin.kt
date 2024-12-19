package com.yuno_flutter.yuno_sdk_android
import android.app.Application
import android.content.Context
import com.yuno.payments.features.payment.startCheckout
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.yuno.payments.core.Yuno
import com.yuno.payments.features.enrollment.initEnrollment
import com.yuno.payments.features.payment.startPaymentSeamlessLite
import com.yuno.payments.features.payment.ui.views.PaymentSelected
import com.yuno.payments.features.payment.updateCheckoutSession
import com.yuno_flutter.yuno_sdk_android.core.utils.extensions.statusConverter
import com.yuno_flutter.yuno_sdk_android.core.utils.extensions.statusEnrollmentConverter
import com.yuno_flutter.yuno_sdk_android.core.utils.keys.Key
import com.yuno_flutter.yuno_sdk_android.features.app_config.method_channel.InitHandler
import com.yuno_flutter.yuno_sdk_android.features.continue_payment.method_channel.ContinuePaymentHandler
import com.yuno_flutter.yuno_sdk_android.features.enrollment.method_channel.EnrollmentHandler
import com.yuno_flutter.yuno_sdk_android.features.payment_methods.views.PaymentMethodFactory
import com.yuno_flutter.yuno_sdk_android.features.seamless.method_channel.SeamlessHandler
import com.yuno_flutter.yuno_sdk_android.features.start_payment.method_channel.StartPaymentHandler
import com.yuno_flutter.yuno_sdk_android.features.start_payment_lite.method_channels.StartPaymentLiteHandler
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class YunoSdkAndroidPlugin :
    FlutterPlugin,
    MethodCallHandler,
    ActivityAware,
    DefaultLifecycleObserver {
    private var initializationError: String? = null
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var activity: FlutterFragmentActivity
    private  lateinit var flutterPluginBindingMajor: FlutterPlugin.FlutterPluginBinding
    override fun onCreate(owner: LifecycleOwner) {
        super.onCreate(owner)
        activity.startCheckout(
               callbackOTT = this::onTokenUpdated,
               callbackPaymentState = this::onPaymentStateChange
           )
        activity.initEnrollment(callbackEnrollmentState = this::onEnrollmentStateChange)
    }
    companion object {
        @JvmStatic
        fun initSdk(application: Application, androidApiKey: String) {
           Yuno.initialize(application,androidApiKey)
        }
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        flutterPluginBindingMajor = flutterPluginBinding
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "yuno/payments")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (initializationError != null ) {
            result.error(
                "yuno initialization failed",
                """The plugin failed to initialize:
${initializationError ?: "Yuno SDK did not initialize."}
Please make sure you follow all the steps detailed inside the README: ""
If you continue to have trouble, follow this discussion to get some support """,
                null
            )
            return
        }
        when (call.method) {
            Key.init -> {
                val init = InitHandler()
                init.handler(
                    call = call,
                    result = result,
                    context = context
                )
            }
            Key.startPayment -> {
                val init = StartPaymentHandler()
                init.handler(
                    call = call,
                    result = result,
                    context = context, activity,
                )
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
            Key.continuePayment -> {
                val continuePayment = ContinuePaymentHandler()
                continuePayment.handler(
                    call = call,
                    result = result,
                    context = context,
                    activity = activity
                )
            }
            Key.enrollmentPayment -> {
                val enrollment = EnrollmentHandler()
                enrollment.handler(
                    call = call,
                    result = result,
                    context = context,
                    activity = activity
                )
            }
            Key.startPaymentSeamless -> {
              val seamlessHandler = SeamlessHandler()
                seamlessHandler.handler(
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
        when {
            binding.activity !is FlutterFragmentActivity -> {
                initializationError =
                    "Your Main Activity ${binding.activity.javaClass} is not a subclass FlutterFragmentActivity."
            }

            else -> {
                activity = binding.activity as FlutterFragmentActivity
                activity.lifecycle.addObserver(this)
                flutterPluginBindingMajor
                    .platformViewRegistry
                    .registerViewFactory("yuno/payment_methods_view", PaymentMethodFactory(flutterPluginBindingMajor, activity))
            }
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
        channel.invokeMethod(Key.ott, token)
    }

    fun onEnrollmentStateChange(enrollmentState: String?) {
        channel.invokeMethod(Key.enrollmentStatus, enrollmentState?.statusEnrollmentConverter())
    }
    fun onPaymentStateChange(paymentState: String?) {
       channel.invokeMethod(Key.status, paymentState?.statusConverter())
    }

}