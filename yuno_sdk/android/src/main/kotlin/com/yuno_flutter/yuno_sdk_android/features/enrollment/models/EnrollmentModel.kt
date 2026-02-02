package com.yuno_flutter.yuno_sdk_android.features.enrollment.models

import com.yuno_flutter.yuno_sdk_android.features.start_payment_lite.models.toStartPaymentLite

data class EnrollmentModel(val countryCode: String, val customerSession:String, val showPaymentStatus: Boolean)

fun Map<String, Any?>.toEnrollment():Result<EnrollmentModel> {
    return try {
        val countryCode = this["countryCode"] as? String  ?: return Result.failure(IllegalArgumentException("Missing or invalid countryCode"))
        val customerSession = this["customerSession"] as? String ?: return Result.failure(IllegalArgumentException("Missing or invalid checkoutSession"))
        val showPaymentStatus = this["showPaymentStatus"] as? Boolean ?: return Result.failure(IllegalArgumentException("Missing or invalid showPaymentStatus"))
        Result.success(EnrollmentModel(countryCode = countryCode, customerSession = customerSession, showPaymentStatus = showPaymentStatus, ))
    } catch (e: Exception) {
        Result.failure(e)
    }
}