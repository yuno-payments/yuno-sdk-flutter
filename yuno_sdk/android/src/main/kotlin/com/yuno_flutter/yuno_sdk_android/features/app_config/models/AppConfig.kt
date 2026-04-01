package com.yuno_flutter.yuno_sdk_android.features.app_config.models

import com.yuno.sdk.YunoLanguage

data class AppConfigModel(
    val apiKey: String,
    val yunoConfiguration: YunoConfiguration,
)

data class YunoConfiguration(
    val lang: YunoLanguage,
    val saveCardEnable: Boolean,
    val keepLoader: Boolean,
)

fun Map<String, Any>.toApiConfig(): Result<AppConfigModel> {
    return try {
        // Extracting and casting values
        val apiKey = this["apiKey"] as? String
            ?: return Result.failure(IllegalArgumentException("Missing or invalid apiKey"))



        val yunoConfigurationMap = this["yunoConfig"] as? Map<*, *> ?: return Result.failure(
            IllegalArgumentException("Missing or invalid configuration")
        )
        val saveCardEnable =
            yunoConfigurationMap["saveCardEnable"] as? Boolean ?: return Result.failure(
                IllegalArgumentException("Missing or invalid saveCardEnable")
            )
        val keepLoader = yunoConfigurationMap["keepLoader"] as? Boolean ?: return Result.failure(
            IllegalArgumentException("Missing or invalid keepLoader")
        )
        val lang =
            yunoConfigurationMap["lang"] as? String ?: return Result.failure(
                IllegalArgumentException("Missing or invalid lang")
            )

        val language = stringToYunoLanguage(lang)
        val safeLang = language ?: YunoLanguage.ENGLISH;
        val yunoConfiguration = YunoConfiguration(
            lang = safeLang,
            saveCardEnable = saveCardEnable,
            keepLoader = keepLoader,
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
    "AR" to YunoLanguage.ARABIC,
    "HI" to YunoLanguage.HINDI,
    "BN" to YunoLanguage.BENGALI,
    "ML" to YunoLanguage.MALAYALAM,
    "UR" to YunoLanguage.URDU,
)


fun stringToYunoLanguage(languageCode: String): YunoLanguage? {
    return languageMap[languageCode.uppercase()]
}