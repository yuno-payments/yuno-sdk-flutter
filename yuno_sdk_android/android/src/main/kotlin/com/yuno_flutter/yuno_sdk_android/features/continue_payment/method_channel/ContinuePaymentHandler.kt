package com.yuno_flutter.yuno_sdk_android.features.continue_payment.method_channel

import android.content.Context
import com.yuno.sdk.payments.continuePayment
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result

class ContinuePaymentHandler {
    fun handler(call: MethodCall, result: Result, context: Context, activity: FlutterFragmentActivity){
       try {
           val showPaymentStatus = call.arguments<Boolean>()
           activity.continuePayment(showPaymentStatus = showPaymentStatus ?: true)
       } catch (e:Exception){
           result.error("4",e.message ?: "Unexpected Error",e.cause)
       }
    }
}