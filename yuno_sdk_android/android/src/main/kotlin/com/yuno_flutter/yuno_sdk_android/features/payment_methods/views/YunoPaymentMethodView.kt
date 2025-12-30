package com.yuno_flutter.yuno_sdk_android.features.payment_methods.views

import android.content.Context
import android.view.View
import android.view.ViewTreeObserver
import android.widget.LinearLayout
import androidx.compose.ui.platform.ComposeView
import com.yuno.sdk.payments.updateCheckoutSession
import com.yuno.presentation.core.components.PaymentMethodListViewComponent
import com.yuno_flutter.yuno_sdk_android.core.utils.keys.Key
import com.yuno_flutter.yuno_sdk_android.features.payment_methods.models.PaymentMethodsViewModel
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import kotlin.math.abs

class YunoPaymentMethodView(
    private val context: Context,
    private val channel: MethodChannel,
    private val activity: FlutterFragmentActivity,
    id: Int,
    creationParams: PaymentMethodsViewModel,
) : PlatformView, MethodChannel.MethodCallHandler {
    private var methodView: View?
    private var heightListener: ViewTreeObserver.OnGlobalLayoutListener? = null
    private var lastHeightDp: Double = -1.0

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
                PaymentMethodListViewComponent(activity = activity, onPaymentSelected = {
                    channel.invokeMethod(Key.onSelected, it)
                }, onUnEnrollSuccess = { })
            }
        }

        // Report the native view height back to Flutter so the Dart widget can size itself correctly.
        // The height is sent in logical pixels (dp) to match Flutter's coordinate system.
        heightListener = ViewTreeObserver.OnGlobalLayoutListener {
            val currentHeightPx = composeView.height
            if (currentHeightPx <= 0) return@OnGlobalLayoutListener

            val density = context.resources.displayMetrics.density
            val currentHeightDp = currentHeightPx / density

            // Avoid spamming the channel for tiny diffs during animation/layout passes.
            if (abs(currentHeightDp - lastHeightDp) > 0.5) {
                lastHeightDp = currentHeightDp
                channel.invokeMethod(Key.onHeightChange, currentHeightDp)
            }
        }
        composeView.viewTreeObserver.addOnGlobalLayoutListener(heightListener)

        methodView = composeView
    }

    override fun getView(): View {
        return methodView ?: View(context)
    }

    override fun dispose() {
        heightListener?.let { listener ->
            methodView?.viewTreeObserver?.removeOnGlobalLayoutListener(listener)
        }
        heightListener = null
        methodView = null
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    }
}