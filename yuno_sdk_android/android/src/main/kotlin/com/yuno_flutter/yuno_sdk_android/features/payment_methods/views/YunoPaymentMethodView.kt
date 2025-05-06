package com.yuno_flutter.yuno_sdk_android.features.payment_methods.views

import android.content.Context
import android.view.View
import android.widget.LinearLayout
import androidx.compose.ui.platform.ComposeView
import com.yuno.payments.features.payment.updateCheckoutSession
import com.yuno.presentation.core.components.PaymentMethodListViewComponent
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
) : PlatformView, MethodChannel.MethodCallHandler {
    private var methodView: View?

    init {
        channel.setMethodCallHandler(this)
        activity.updateCheckoutSession(
            creationParams.checkoutSession,
            creationParams.countryCode,
        )

        val composeView = ComposeView(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            )
            setContent {
                PaymentMethodListViewComponent(onPaymentSelected = {
                    channel.invokeMethod(Key.onSelected, it)
                }, onUnEnrollSuccess = { })
            }
        }

        methodView = composeView
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