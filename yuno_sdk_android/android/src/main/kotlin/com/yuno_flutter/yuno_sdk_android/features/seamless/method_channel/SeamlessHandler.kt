package com.yuno_flutter.yuno_sdk_android.features.seamless.method_channel

import android.content.Context
import com.yuno.payments.features.payment.startPaymentLite
import com.yuno.payments.features.payment.startPaymentSeamlessLite
import com.yuno.payments.features.payment.ui.views.PaymentSelected
import com.yuno.payments.features.payment.updateCheckoutSession
import com.yuno_flutter.yuno_sdk_android.core.utils.extensions.statusConverter
import com.yuno_flutter.yuno_sdk_android.features.start_payment_lite.models.toStartPaymentLite
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result

class SeamlessHandler {

    fun handler(call: MethodCall, result: Result, context: Context, activity: FlutterFragmentActivity){
        try {
            val argument = call.arguments<Map<String, Any>>()
            val either = argument?.toStartPaymentLite()
            either?.onSuccess { model ->
                activity.updateCheckoutSession(
                    checkoutSession = model.checkoutSession,
                    countryCode = model.countryCode
                )
                activity.startPaymentSeamlessLite(
                    paymentSelected = PaymentSelected(
                        paymentMethodType = model.paymentMethodSelected.paymentMethodType,
                        vaultedToken = model.paymentMethodSelected.vaultedToken,
                    ),
                    showPaymentStatus = model.showPaymentStatus,
                    callbackPaymentState = { paymentState ->
                        result.success(paymentState?.statusConverter())
                    },
                )
            }?.onFailure { exception ->  return result.error(
                "5",
                "Failure: An error occurred - ${exception.message}",
                "Invalid arguments in json cast"
            ) }
        } catch (e: Exception) {
            return result.error("SOMETHING_WENT_WRONG", "Failure", e.message)
        }
    }
}