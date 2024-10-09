package com.yuno_flutter.yuno_sdk_android.features.payment_methods.views
import android.app.Activity
import android.app.Application
import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.View
import android.view.ViewTreeObserver
import android.widget.ScrollView
import androidx.core.view.doOnDetach
import com.yuno.payments.features.payment.startCheckout
import com.yuno.payments.features.payment.ui.views.PaymentMethodListView
import com.yuno.payments.features.payment.updateCheckoutSession
import com.yuno_flutter.yuno_sdk_android.features.payment_methods.models.PaymentMethodsViewModel
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class YunoPaymentMethodView(
    private val context: Context,
    private val channel: MethodChannel,
    private val activity: FlutterFragmentActivity,
    id: Int,
    creationParams: PaymentMethodsViewModel,

    ) : PlatformView, MethodChannel.MethodCallHandler, Application.ActivityLifecycleCallbacks {

    private  var dynamicView: PaymentMethodListView?
    init {
        channel.setMethodCallHandler(this)
        activity.updateCheckoutSession(creationParams.checkoutSession,creationParams.countryCode)
        dynamicView = PaymentMethodListView(context).apply {
            setOnSelectedEvent { selected ->
                channel.invokeMethod("onSelected", selected)
            }
        }
    }
    override fun getView(): View {
        return dynamicView!!
    }
    override fun dispose() {
        Log.d("PlatformView", "Dispose llamado, liberando recursos")
        dynamicView?.let {
            it.parent?.let { parent ->
                (parent as? ScrollView)?.removeView(it)
            }
        }
        dynamicView = null
        dynamicView = null

        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        println("hello")
    }

    override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
        TODO("Not yet implemented")
    }

    override fun onActivityStarted(activity: Activity) {
        TODO("Not yet implemented")
    }

    override fun onActivityResumed(activity: Activity) {
        TODO("Not yet implemented")
    }

    override fun onActivityPaused(activity: Activity) {
        TODO("Not yet implemented")
    }

    override fun onActivityStopped(activity: Activity) {
        TODO("Not yet implemented")
    }

    override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {
        TODO("Not yet implemented")
    }

    override fun onActivityDestroyed(activity: Activity) {
        TODO("Not yet implemented")
    }

}