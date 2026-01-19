package com.yuno_flutter.yuno_sdk_android.core.config

/**
 * Configuration object that stores payment-related settings in memory.
 *
 * This object maintains the showPaymentStatus value for the current payment session.
 * The value is reset each time a new payment is started via startPayment or startPaymentLite.
 */
object PaymentConfig {
    private var showPaymentStatus: Boolean? = null
    
    /**
     * Sets the showPaymentStatus value for the current payment session.
     *
     * @param value The boolean value indicating whether to show payment status
     */
    fun setShowPaymentStatus(value: Boolean) {
        showPaymentStatus = value
    }
    
    /**
     * Gets the current showPaymentStatus value.
     *
     * @return The saved boolean value, or null if not set
     */
    fun getShowPaymentStatus(): Boolean? {
        return showPaymentStatus
    }
    
    /**
     * Resets the showPaymentStatus value.
     *
     * This should be called when starting a new payment session.
     */
    fun reset() {
        showPaymentStatus = null
    }
}
