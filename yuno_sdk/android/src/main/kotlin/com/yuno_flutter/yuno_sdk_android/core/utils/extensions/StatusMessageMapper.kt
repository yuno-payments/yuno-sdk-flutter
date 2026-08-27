package com.yuno_flutter.yuno_sdk_android.core.utils.extensions

import com.yuno.payments.features.payment.models.StatusMessage
import com.yuno_flutter.yuno_sdk_android.core.utils.keys.Key

/**
 * Serializes a native [StatusMessage] into the map shape expected by the Flutter
 * side (`YunoStatusMessage`). Returns `null` when there is no message so the
 * absence is forwarded transparently.
 */
fun StatusMessage?.toMap(): Map<String, Any?>? {
    val message = this ?: return null
    return mapOf(
        "source" to message.source,
        "code" to message.code,
        "reason" to message.reason,
        "raw" to message.raw,
        "context" to message.context,
    )
}

/**
 * Builds the `{ status, message }` payload delivered to Flutter for a payment or
 * enrollment status change.
 */
fun statusPayload(
    status: Int?,
    substatus: String?,
    message: StatusMessage?,
): Map<String, Any?> = mapOf(
    Key.status to status,
    Key.substatus to substatus,
    Key.message to message.toMap(),
)
