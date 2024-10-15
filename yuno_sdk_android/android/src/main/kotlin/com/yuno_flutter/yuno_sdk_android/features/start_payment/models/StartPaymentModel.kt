package com.yuno_flutter.yuno_sdk_android.features.start_payment.models
data class StartPayment( val showPaymentStatus: Boolean,)

fun Map<String, Any>.toStartPayment(): StartPayment {
    val showPaymentStatus = this["showPaymentStatus"] as? Boolean ?: true
    return StartPayment(showPaymentStatus)
}