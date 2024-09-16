package com.example.yuno_sdk_android.features.start_payment_lite.method_channels
import android.content.Context
import com.example.yuno_sdk_android.features.start_payment_lite.models.toStartPaymentLite
import com.yuno.payments.features.payment.continuePayment
import com.yuno.payments.features.payment.startPaymentLite
import com.yuno.payments.features.payment.ui.views.PaymentSelected
import com.yuno.payments.features.payment.updateCheckoutSession
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result

class StartPaymentLiteHandler {

    fun handler(call: MethodCall, result: Result, context: Context, activity: FlutterFragmentActivity){
        try {
            val argument = call.arguments<Map<String, Any>>()
            val either = argument?.toStartPaymentLite()
            either?.onSuccess { model ->
                activity.updateCheckoutSession(
                    checkoutSession = model.checkoutSession,
                    countryCode = model.countryCode
                )
                activity.startPaymentLite(
                    paymentSelected = PaymentSelected(
                        paymentMethodType = model.paymentMethodSelected.paymentMethodType,
                        vaultedToken = model.paymentMethodSelected.vaultedToken,
                    ),
                    showPaymentStatus = model.showPaymentStatus
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