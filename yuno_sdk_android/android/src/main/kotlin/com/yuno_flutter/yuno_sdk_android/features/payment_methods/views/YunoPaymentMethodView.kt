package com.yuno_flutter.yuno_sdk_android.features.payment_methods.views
import android.content.Context

import android.view.View
import android.widget.FrameLayout
import androidx.fragment.app.FragmentActivity

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class YunoPaymentMethodView(
    private val context: Context,
    channel: MethodChannel,
    id: Int,
    creationParams: Map<String?, Any?>?,
) : PlatformView, MethodChannel.MethodCallHandler {
    private val containerView: FrameLayout = FrameLayout(context)

    override fun getView(): View {
        return containerView
    }

    init {

        val fragment = PaymentMethodFragment() // Replace this with your actual fragment
        val fragmentTransaction = (context as FragmentActivity).supportFragmentManager.beginTransaction()
        containerView.id = fragment.id
        fragmentTransaction.add(containerView.id, fragment)
        fragmentTransaction.commitAllowingStateLoss()
    }

    override fun dispose() {


    }
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        println("hello")
    }

}