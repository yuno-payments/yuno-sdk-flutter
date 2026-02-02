package com.yuno_flutter.yuno_sdk_android.features.receive_deeplink.method_channel

import android.content.Context
import android.util.Log
import com.yuno.sdk.enrollment.startEnrollment
import com.yuno.sdk.payments.continuePayment
import com.yuno.sdk.payments.updateCheckoutSession
import com.yuno_flutter.yuno_sdk_android.core.config.PaymentConfig
import com.yuno_flutter.yuno_sdk_android.core.utils.extensions.statusConverter
import com.yuno_flutter.yuno_sdk_android.core.utils.keys.Key
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import java.net.URLDecoder

/**
 * Handler for processing deeplink URLs.
 *
 * This handler analyzes the incoming deeplink URL and checks for:
 * - checkoutSession: Updates the checkout session and continues the payment
 * - customerSession: Starts enrollment with the customer session
 * Both use the previously saved showPaymentStatus value.
 */
class ReceiveDeeplinkHandler {
    companion object {
        private const val TAG = "ReceiveDeeplinkHandler"
    }
    
    fun handler(call: MethodCall, result: Result, context: Context, activity: FlutterFragmentActivity, channel: MethodChannel) {
        try {
            val urlString = call.arguments<String>()
            Log.d(TAG, "Received deeplink URL: $urlString")
            
            if (urlString.isNullOrEmpty()) {
                Log.e(TAG, "URL is null or empty")
                result.error("INVALID_ARGUMENTS", "URL cannot be null or empty", null)
                return
            }
            
            // Parse query parameters from the URL
            val queryParams = parseQueryParams(urlString)
            Log.d(TAG, "Parsed query params: $queryParams")
            
            val checkoutSession = queryParams["checkoutSession"]
            val customerSession = queryParams["customerSession"]
            val countryCode = queryParams["countryCode"] ?: ""
            
            
            if (checkoutSession != null && checkoutSession.isNotEmpty()) {
                // Get the saved showPaymentStatus value from memory config
                val showPaymentStatus = PaymentConfig.getShowPaymentStatus() ?: true
                
                // Update checkout session and continue payment
                activity.updateCheckoutSession(
                    checkoutSession = checkoutSession,
                    countryCode = countryCode
                )
                
                // Call continuePayment with checkoutSession and countryCode from URL
                // Include callback to notify Flutter client about payment state
                activity.continuePayment(
                    showPaymentStatus = showPaymentStatus,
                    checkoutSession = checkoutSession,
                    countryCode = if (countryCode.isNotEmpty()) countryCode else null,
                    callbackPaymentState = { paymentState, data ->
                        val convertedStatus = paymentState?.statusConverter()
                        channel.invokeMethod(Key.status, convertedStatus)
                    }
                )
                result.success(null)
                return
            }
            
            // Handle customerSession (for enrollment)
            if (customerSession != null && customerSession.isNotEmpty()) {
                // Get the saved showPaymentStatus value from memory config
                val showPaymentStatus = PaymentConfig.getShowPaymentStatus() ?: true
                
                // Start enrollment
                activity.startEnrollment(
                    countryCode = countryCode.ifEmpty { "" },
                    customerSession = customerSession,
                    showEnrollmentStatus = showPaymentStatus
                )
                result.success(null)
                return
            }
            
            // No relevant session found in the URL
            result.success(null)
        } catch (e: Exception) {
            result.error("DEEPLINK_ERROR", "Error processing deeplink: ${e.message}", e.cause)
        }
    }
    
    /**
     * Parses query parameters from a URL string.
     *
     * @param urlString The URL string to parse
     * @return A map of query parameter names to their decoded values
     */
    private fun parseQueryParams(urlString: String): Map<String, String> {
        val queryParams = mutableMapOf<String, String>()
        
        try {
            val queryStartIndex = urlString.indexOf('?')
            if (queryStartIndex == -1) {
                return queryParams
            }
            
            val queryString = urlString.substring(queryStartIndex + 1)
            val pairs = queryString.split("&")
            
            for (pair in pairs) {
                val equalIndex = pair.indexOf('=')
                if (equalIndex > 0) {
                    val key = URLDecoder.decode(pair.substring(0, equalIndex), "UTF-8")
                    val value = URLDecoder.decode(pair.substring(equalIndex + 1), "UTF-8")
                    queryParams[key] = value
                } else if (pair.isNotEmpty()) {
                    val key = URLDecoder.decode(pair, "UTF-8")
                    queryParams[key] = ""
                }
            }
        } catch (e: Exception) {
            // If parsing fails, return empty map
        }
        
        return queryParams
    }
}
