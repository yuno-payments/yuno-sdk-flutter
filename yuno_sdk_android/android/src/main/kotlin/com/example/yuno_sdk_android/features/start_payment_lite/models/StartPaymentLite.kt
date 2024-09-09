package com.example.yuno_sdk_android.features.start_payment_lite.models

import com.example.yuno_sdk_android.features.app_config.models.AppConfigModel
import com.example.yuno_sdk_android.features.app_config.models.toApiConfig

data class StartPaymentLite(
    val countryCode: String,
    val showPaymentStatus: Boolean,
    val checkoutSession: String,
    val paymentMethodSelected: PaymentMethod
)



fun Map<String, Any>.toStartPaymentLite(): Result<StartPaymentLite> {

        return try {
            val countryCode = this["countryCode"] as? String  ?: return Result.failure(IllegalArgumentException("Missing or invalid countryCode"))
            val checkoutSession = this["checkoutSession"] as? String ?: return Result.failure(IllegalArgumentException("Missing or invalid checkoutSession"))
            val showPaymentStatus = this["showPaymentStatus"] as? Boolean ?: return Result.failure(IllegalArgumentException("Missing or invalid showPaymentStatus"))
            val paymentMethodSelected = this["paymentMethodSelected"] as? Map<*, *> ?: return Result.failure(
                IllegalArgumentException("Missing or invalid paymentMethodSelected")
            )
            val vaultedToken = paymentMethodSelected["vaultedToken"] as? String?
            val paymentMethodType = paymentMethodSelected["paymentMethodType"] as? String  ?: return Result.failure(IllegalArgumentException("Missing or invalid paymentMethodType"))

            Result.success(
                StartPaymentLite(
                  countryCode = countryCode,
                  showPaymentStatus = showPaymentStatus,
                  checkoutSession = checkoutSession,
                  paymentMethodSelected = PaymentMethod(
                      vaultedToken = vaultedToken,
                      paymentMethodType = paymentMethodType
                  )
                )
            )
        } catch (e: Exception){
            Result.failure(e)
        }
}