package com.yuno_flutter.yuno_sdk_android.features.payment_methods.views

import android.content.Context
import android.util.Log
import android.view.View
import android.widget.LinearLayout
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.wrapContentHeight
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.unit.Dp
import com.yuno.sdk.payments.updateCheckoutSession
import com.yuno.presentation.core.components.PaymentMethodListViewComponent
import com.yuno.presentation.core.components.PaymentSelected
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
    private var lastHeightDp: Double = -1.0
    private var paymentMethodIsSelected: Boolean = false

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
                Box(modifier = Modifier.wrapContentHeight()) {
                    PaymentMethodListViewComponent(
                        activity = activity,
                        onPaymentSelected = { isSelected: Boolean, paymentMethodInfo: PaymentSelected? ->
                            paymentMethodIsSelected = isSelected
                            Log.i("PaymentMethodView", "Payment Method Selected: ${paymentMethodInfo?.toString().orEmpty()}")
                            val paymentMethodData = if (paymentMethodInfo != null) {
                                mapOf(
                                    "vaultedToken" to paymentMethodInfo.vaultedToken,
                                    "paymentMethodType" to paymentMethodInfo.paymentMethodType
                                )
                            } else {
                                mapOf(
                                    "vaultedToken" to null,
                                    "paymentMethodType" to ""
                                )
                            }
                            channel.invokeMethod(Key.onSelected, paymentMethodData)
                        },
                        onUnEnrollSuccess = { success: Boolean ->
                            Log.i("PaymentMethodView", "UnEnroll Success: $success")
                        },
                        onSizeChanged = { width: Dp, height: Dp ->
                            val heightDp = height.value.toDouble()
                            Log.i("PaymentMethodView", "Size Changed: ${width.value}dp x ${height.value}dp")
                            // Si el valor es > 0 y cambió, notificamos a Flutter
                            if (heightDp > 0 && abs(heightDp - lastHeightDp) > 0.5) {
                                lastHeightDp = heightDp
                                // Aseguramos que el envío ocurra en el thread de UI
                                activity.runOnUiThread {
                                    channel.invokeMethod(Key.onHeightChange, heightDp)
                                }
                            }
                        },
                    )
                }
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