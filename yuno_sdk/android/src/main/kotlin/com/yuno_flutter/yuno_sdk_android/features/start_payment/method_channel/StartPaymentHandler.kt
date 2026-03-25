package com.yuno_flutter.yuno_sdk_android.features.start_payment.method_channel

import android.content.Context
import com.yuno.sdk.payments.startPayment
import com.yuno.sdk.Yuno
import com.yuno.sdk.YunoPlatform
import com.yuno_flutter.yuno_sdk_android.core.config.PaymentConfig
import com.yuno_flutter.yuno_sdk_android.features.start_payment.models.toStartPayment
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result

class StartPaymentHandler {
    fun handler(call: MethodCall, result: Result, context: Context, activity: FlutterFragmentActivity){
        try {
            val argument = call.arguments<Map<String, Any>>()
            val model = argument?.toStartPayment()
            val showPaymentStatus = model?.showPaymentStatus ?: true
            // Reset the payment config when starting a new payment
            PaymentConfig.reset()
            // Save the showPaymentStatus for potential deeplink handling
            PaymentConfig.setShowPaymentStatus(showPaymentStatus)
            Yuno.setPlatform(YunoPlatform.FLUTTER)
            activity.startPayment(showPaymentStatus = showPaymentStatus)
        } catch (e: Exception) {
            return result.error("SOMETHING_WENT_WRONG", "Failure", e.message)
        }

    }
}