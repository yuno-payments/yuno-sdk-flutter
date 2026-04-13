package com.yuno_flutter.yuno_sdk_android.features.app_config.method_channel
import android.content.Context
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import com.yuno_flutter.yuno_sdk_android.features.app_config.models.AppearanceModel
import com.yuno_flutter.yuno_sdk_android.features.app_config.models.toApiConfig
import com.yuno.sdk.Yuno
import com.yuno.sdk.YunoButtonStyles
import com.yuno.sdk.YunoConfig
import com.yuno.sdk.YunoStyles
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
                val styles = appConfig.appearance?.let { buildYunoStyles(context, it) }
                Yuno.initialize(
                    context,
                    appConfig.apiKey,
                    config = YunoConfig(
                        language = appConfig.yunoConfiguration.lang,
                        saveCardEnabled = appConfig.yunoConfiguration.saveCardEnable,
                        keepLoader = appConfig.yunoConfiguration.keepLoader,
                        styles = styles,
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

    private fun buildYunoStyles(context: Context, appearance: AppearanceModel): YunoStyles {
        val fontFamily = appearance.fontFamily?.let { resolveFontFamily(context, it) }
        val buttonStyles = YunoButtonStyles(
            backgroundColor = appearance.buttonBackgroundColor?.toComposeColor(),
            contentColor = appearance.buttonTitleColor?.toComposeColor(),
            fontFamily = fontFamily,
        )
        return YunoStyles(
            fontFamily = fontFamily,
            buttonStyles = buttonStyles,
        )
    }

    private fun resolveFontFamily(context: Context, fontName: String): FontFamily? {
        val fontResId = context.resources.getIdentifier(fontName, "font", context.packageName)
        if (fontResId != 0) {
            return FontFamily(Font(fontResId, FontWeight.Normal))
        }
        return null
    }

    private fun Int.toComposeColor(): Color = Color(this)
}