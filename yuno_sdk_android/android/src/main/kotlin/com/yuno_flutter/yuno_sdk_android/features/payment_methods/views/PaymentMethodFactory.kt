package com.yuno_flutter.yuno_sdk_android.features.payment_methods.views

import android.content.Context
import com.yuno_flutter.yuno_sdk_android.features.payment_methods.models.mapToPaymentMethodsViewModel
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory


class PaymentMethodFactory(
    private val flutterPluginBinding: FlutterPlugin.FlutterPluginBinding,
    private val activity: FlutterFragmentActivity
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        val channel = MethodChannel(flutterPluginBinding.binaryMessenger, "yuno/payment_methods_view/${viewId}")
        val creationParams = args as? Map<String?, Any?>?
        if(context == null){
            throw AssertionError("Context is not allowed to be null when launching card view.")
        }
        val model = mapToPaymentMethodsViewModel(creationParams)
        return YunoPaymentMethodView(context ,channel,  activity,viewId, model)
    }

}

