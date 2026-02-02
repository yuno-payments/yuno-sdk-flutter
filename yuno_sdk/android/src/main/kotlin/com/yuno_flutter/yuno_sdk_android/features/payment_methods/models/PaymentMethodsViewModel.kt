package com.yuno_flutter.yuno_sdk_android.features.payment_methods.models

data class PaymentMethodsViewModel(
    val checkoutSession: String,
    val countryCode: String,
    val width: Double
)

fun mapToPaymentMethodsViewModel(map: Map<String?, Any?>?): PaymentMethodsViewModel {
    val countryCode = map?.get("countryCode") as? String ?: ""
    val checkoutSession = map?.get("checkoutSession") as? String ?: ""
    val width = (map?.get("width") as? Number)?.toDouble() ?: 0.0

    return PaymentMethodsViewModel(
       checkoutSession,
        countryCode,
        width
    )
}
