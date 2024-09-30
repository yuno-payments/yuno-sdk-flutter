package com.yuno_flutter.yuno_sdk_android.features.app_config.method_channel

import android.content.Context
import com.yuno_flutter.yuno_sdk_android.features.app_config.models.toApiConfig
import com.yuno_flutter.yuno_sdk_android.features.app_config.models.toCardFLowSDK
import com.yuno.payments.core.Yuno
import com.yuno.payments.core.YunoConfig
import com.yuno.payments.core.YunoLanguage
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result

class InitHandler {

    fun handler(call: MethodCall, result: Result, context: Context){
        try {
            val argument = call.arguments<Map<String, Any>>()
            val either = argument?.toApiConfig()

            either?.onSuccess { appConfig ->
                if (appConfig.apiKey.isEmpty()) {
                    return result.error(
                        "4",
                        "ApiKey is empty",
                        "ApiKey must be necessary for starting to use Yuno SDK"
                    )
                }

                Yuno.initialize(
                    context,
                    appConfig.apiKey,
                    config = YunoConfig(
                        language = appConfig.yunoConfiguration.lang,
                        saveCardEnabled = appConfig.yunoConfiguration.saveCardEnable,
                        cardFormDeployed = appConfig.yunoConfiguration.cardFormDeployed,
                        isDynamicViewEnabled = appConfig.yunoConfiguration.isDynamicViewEnable,
                        keepLoader = appConfig.yunoConfiguration.keepLoader,
                        cardFlow = appConfig.yunoConfiguration.cardFlow.toCardFLowSDK()
                    )
                )
                return result.success(true)
            }?.onFailure { exception ->
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