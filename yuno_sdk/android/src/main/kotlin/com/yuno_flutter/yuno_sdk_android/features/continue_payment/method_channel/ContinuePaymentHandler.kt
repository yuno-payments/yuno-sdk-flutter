package com.yuno_flutter.yuno_sdk_android.features.continue_payment.method_channel

import android.content.Context
import android.util.Log
import com.yuno.sdk.payments.continuePayment
import com.yuno_flutter.yuno_sdk_android.core.config.PaymentConfig
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result

class ContinuePaymentHandler {
    companion object {
        private const val TAG = "ContinuePaymentHandler"
    }
    
    fun handler(call: MethodCall, result: Result, context: Context, activity: FlutterFragmentActivity, onState: (String?, String?) -> Unit){
       try {
           val showPaymentStatus = call.arguments<Boolean>() ?: true

           // Get current saved value before updating
           val previousShowPaymentStatus = PaymentConfig.getShowPaymentStatus()

           // Save the showPaymentStatus value in memory for later use in deeplink handling
           PaymentConfig.setShowPaymentStatus(showPaymentStatus)

           // Re-register the payment-state callback per call: Yuno.init() clears it via clearPaymentFlowCallbacks() (native SDK >= 2.14.0)
           activity.continuePayment(showPaymentStatus = showPaymentStatus, callbackPaymentState = onState)
       } catch (e:Exception){
           result.error("4",e.message ?: "Unexpected Error",e.cause)
       }
    }
}