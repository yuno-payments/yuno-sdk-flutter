package com.yuno_flutter.yuno_sdk_android.features.start_payment.method_channel

import android.content.Context
import com.yuno.sdk.payments.startPayment
import com.yuno_flutter.yuno_sdk_android.features.start_payment.models.toStartPayment
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result

class StartPaymentHandler {
    fun handler(call: MethodCall, result: Result, context: Context, activity: FlutterFragmentActivity){
        try {
            val argument = call.arguments<Map<String, Any>>()
            val model = argument?.toStartPayment()
            activity.startPayment(showPaymentStatus = model?.showPaymentStatus ?: true)
        } catch (e: Exception) {
            return result.error("SOMETHING_WENT_WRONG", "Failure", e.message)
        }

    }
}