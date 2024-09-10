package com.example.yuno_sdk_android.core.utils.extensions
import com.yuno.payments.features.payment.PAYMENT_STATE_FAIL
import com.yuno.payments.features.payment.PAYMENT_STATE_INTERNAL_ERROR
import com.yuno.payments.features.payment.PAYMENT_STATE_PROCESSING
import com.yuno.payments.features.payment.PAYMENT_STATE_REJECT
import com.yuno.payments.features.payment.PAYMENT_STATE_STATE_CANCELED_BY_USER
import com.yuno.payments.features.payment.PAYMENT_STATE_SUCCEEDED

fun String.statusConverter(): Int {
    return when (this) {
        PAYMENT_STATE_REJECT -> 0
        PAYMENT_STATE_SUCCEEDED -> 1
        PAYMENT_STATE_FAIL -> 2
        PAYMENT_STATE_PROCESSING -> 3
        PAYMENT_STATE_INTERNAL_ERROR -> 4
        PAYMENT_STATE_STATE_CANCELED_BY_USER -> 5
        else -> 4
    }
}