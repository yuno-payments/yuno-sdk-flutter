package com.yuno_flutter.yuno_sdk_android.features.payment_methods.views
import android.content.Context
import android.view.View
import android.view.ViewGroup
import android.widget.ScrollView
import androidx.core.view.children
import com.yuno.payments.features.payment.ui.views.PaymentMethodListView
import com.yuno.payments.features.payment.updateCheckoutSession
import com.yuno_flutter.yuno_sdk_android.core.utils.keys.Key
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
    ) : PlatformView, MethodChannel.MethodCallHandler{
    private  var methodView: ScrollView?
    init {
        channel.setMethodCallHandler(this)
        activity.updateCheckoutSession(creationParams.checkoutSession,creationParams.countryCode)
        val scrollView = ScrollView(context).apply {
            layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
        }
        val paymentMethodListView = PaymentMethodListView(context, lifecycleOwner = activity).apply {
            setOnSelectedEvent { it ->
                channel.invokeMethod(Key.onSelected,it)
            }
        }
        scrollView.addView(paymentMethodListView)
        methodView = scrollView
        scrollView.addOnLayoutChangeListener { _, _, _, _, _, _, _, _, _ ->
            scrollView.children.forEach { it ->
                val displayMetrics = context.resources.displayMetrics
                val heightInDp = it.height / displayMetrics.density
                channel.invokeMethod(Key.onHeightChange, heightInDp.toDouble())
            }
        }
    }
    override fun getView(): View {
        return methodView ?: View(context)
    }
    override fun dispose() {
        methodView = null
        channel.setMethodCallHandler(null)
    }
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    }
}