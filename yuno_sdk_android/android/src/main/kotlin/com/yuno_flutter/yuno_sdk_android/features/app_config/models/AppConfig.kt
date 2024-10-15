package com.yuno_flutter.yuno_sdk_android.features.app_config.models

import com.yuno.payments.core.YunoLanguage

data class AppConfigModel(
    val apiKey: String,
    val yunoConfiguration: YunoConfiguration,
)

data class YunoConfiguration(
    val lang: YunoLanguage,
    val cardFlow: CardFlow,
    val saveCardEnable: Boolean,
    val keepLoader: Boolean,
    val isDynamicViewEnable: Boolean,
    val cardFormDeployed: Boolean
)

fun Map<String, Any>.toApiConfig(): Result<AppConfigModel> {
    return try {
        // Extracting and casting values
        val apiKey = this["apiKey"] as? String
            ?: return Result.failure(IllegalArgumentException("Missing or invalid apiKey"))



        val yunoConfigurationMap = this["yunoConfig"] as? Map<*, *> ?: return Result.failure(
            IllegalArgumentException("Missing or invalid configuration")
        )
        val cardflow = try {
            CardFlow.valueOf(
                yunoConfigurationMap["cardFlow"] as? String
                    ?: throw IllegalArgumentException("Missing or invalid cardflow")
            )
        } catch (e: IllegalArgumentException) {
            return Result.failure(e)
        }
        val saveCardEnable =
            yunoConfigurationMap["saveCardEnable"] as? Boolean ?: return Result.failure(
                IllegalArgumentException("Missing or invalid saveCardEnable")
            )
        val keepLoader = yunoConfigurationMap["keepLoader"] as? Boolean ?: return Result.failure(
            IllegalArgumentException("Missing or invalid keepLoader")
        )
        val isDynamicViewEnable =
            yunoConfigurationMap["isDynamicViewEnable"] as? Boolean ?: return Result.failure(
                IllegalArgumentException("Missing or invalid isDynamicViewEnable")
            )

        val cardFormDeployed =
            yunoConfigurationMap["cardFormDeployed"] as? Boolean ?: return Result.failure(
                IllegalArgumentException("Missing or invalid cardFormDeployed")
            )

        val lang =
            yunoConfigurationMap["lang"] as? String ?: return Result.failure(
                IllegalArgumentException("Missing or invalid isDynamicViewEnable")
            )

        val language = stringToYunoLanguage(lang)
        val safeLang = language ?: YunoLanguage.ENGLISH;
        val yunoConfiguration = YunoConfiguration(
            lang = safeLang,
            cardFlow = cardflow,
            saveCardEnable = saveCardEnable,
            keepLoader = keepLoader,
            isDynamicViewEnable = isDynamicViewEnable,
            cardFormDeployed = cardFormDeployed,
        )

        Result.success(
            AppConfigModel(
                apiKey = apiKey,
                yunoConfiguration = yunoConfiguration,
            )
        )

    } catch (e: Exception) {
        Result.failure(e)
    }
}

val languageMap = mapOf(
    "EN" to YunoLanguage.ENGLISH,
    "ES" to YunoLanguage.SPANISH,
    "PT" to YunoLanguage.PORTUGUESE,
    "ID" to YunoLanguage.INDONESIAN,
    "MS" to YunoLanguage.MALAYSIAN,
)


fun stringToYunoLanguage(languageCode: String): YunoLanguage? {
    return languageMap[languageCode.uppercase()]
}