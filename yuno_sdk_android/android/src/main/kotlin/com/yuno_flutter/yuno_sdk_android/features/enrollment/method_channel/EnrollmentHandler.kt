package com.yuno_flutter.yuno_sdk_android.features.enrollment.method_channel
import android.content.Context
import com.yuno.payments.features.enrollment.startEnrollment
import com.yuno_flutter.yuno_sdk_android.features.enrollment.models.toEnrollment
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result

class EnrollmentHandler {

    fun handler(call: MethodCall, result: Result, context: Context, activity: FlutterFragmentActivity){
        try {
            val argument = call.arguments<Map<String, Any>>()
            val either = argument?.toEnrollment()

            either
                ?.onSuccess { model ->
                    if (model.customerSession.isEmpty()) {
                        return result.error(
                            "4",
                            "CustomerSession is empty",
                            "CustomerSession must be necessary for startEnrollment Method"
                        )
                    }
                    activity.startEnrollment(
                        countryCode = model.countryCode,
                        customerSession = model.customerSession,
                        showEnrollmentStatus = model.showPaymentStatus,
                    )
                }
                ?.onFailure { exception ->
                    return result.error(
                        "5",
                        "Failure: An error occurred - ${exception.message}",
                        "Invalid arguments in json cast"
                    )
                }

        } catch (e: Exception) {
            return result.error("SOMETHING_WENT_WRONG", "Failure", e.message)
        }

    }
}