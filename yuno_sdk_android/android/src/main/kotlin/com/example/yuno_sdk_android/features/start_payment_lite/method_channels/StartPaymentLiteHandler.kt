package com.example.yuno_sdk_android.features.start_payment_lite.method_channels

import android.content.Context
import com.yuno.payments.features.payment.startPaymentLite
import com.yuno.payments.features.payment.ui.views.PaymentSelected
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result

class StartPaymentLiteHandler {

    fun handler(call: MethodCall, result: Result, context: Context, activity:FlutterFragmentActivity){
        try {
            //TODO: implement dynamic startPayment
            activity.startPaymentLite(
                paymentSelected = PaymentSelected(
                    paymentMethodType = "",
                    vaultedToken = "",
                )
            )
            result.success(true)
        } catch (e: Exception) {
           //TODO: handle exception
        }
    }
}