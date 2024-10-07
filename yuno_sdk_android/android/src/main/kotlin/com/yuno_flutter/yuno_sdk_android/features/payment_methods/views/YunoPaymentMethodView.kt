package com.yuno_flutter.yuno_sdk_android.features.payment_methods.views

import android.content.Context
import android.view.View
import android.widget.FrameLayout
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.OnLifecycleEvent
import com.yuno.payments.features.payment.ui.views.DynamicPaymentMethodListView
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class YunoPaymentMethodView(
    private val context: Context,
    channel: MethodChannel,
    id: Int,
    creationParams: Map<String?, Any?>?,
) : PlatformView, MethodChannel.MethodCallHandler {

    private val containerView: FrameLayout
    init {

        channel.setMethodCallHandler(this)
        containerView = FrameLayout(context)
        containerView.id = View.generateViewId()
        if (context is FragmentActivity) {
            addFragmentToContainer(context)
        }
    }

    private fun addFragmentToContainer(activity: FragmentActivity) {
        val fragment = PaymentMethodFragment()
        val fragmentTransaction = activity.supportFragmentManager.beginTransaction()
        fragmentTransaction.replace(containerView.id, fragment).commit()
    }


    override fun getView(): View {
        return containerView
    }

    override fun dispose() {
        TODO("Not yet implemented")
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        TODO("Not yet implemented")
    }



}