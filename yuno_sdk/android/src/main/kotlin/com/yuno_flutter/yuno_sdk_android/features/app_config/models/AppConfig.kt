package com.yuno_flutter.yuno_sdk_android.features.app_config.models

import com.yuno.sdk.YunoLanguage

data class AppConfigModel(
    val apiKey: String,
    val yunoConfiguration: YunoConfiguration,
    val appearance: AppearanceModel? = null,
)

data class YunoConfiguration(
    val lang: YunoLanguage,
    val saveCardEnable: Boolean,
    val keepLoader: Boolean,
)

data class AppearanceModel(
    val fontFamily: String? = null,
    val accentColor: Int? = null,
    val buttonBackgroundColor: Int? = null,
    val buttonTitleColor: Int? = null,
    val buttonBorderColor: Int? = null,
    val secondaryButtonBackgroundColor: Int? = null,
    val secondaryButtonTitleColor: Int? = null,
    val secondaryButtonBorderColor: Int? = null,
    val disableButtonBackgroundColor: Int? = null,
    val disableButtonTitleColor: Int? = null,
    val checkboxColor: Int? = null,
)

fun Map<String, Any>.toApiConfig(): Result<AppConfigModel> {
    return try {
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

        val configurationMap = this["configuration"] as? Map<*, *>
        val appearanceMap = configurationMap?.get("appearance") as? Map<*, *>
        val appearance = appearanceMap?.let {
            AppearanceModel(
                fontFamily = it["fontFamily"] as? String,
                accentColor = it["accentColor"] as? Int,
                buttonBackgroundColor = it["buttonBackgrounColor"] as? Int,
                buttonTitleColor = it["buttonTitleBackgrounColor"] as? Int,
                buttonBorderColor = it["buttonBorderBackgrounColor"] as? Int,
                secondaryButtonBackgroundColor = it["secondaryButtonBackgrounColor"] as? Int,
                secondaryButtonTitleColor = it["secondaryButtonTitleBackgrounColor"] as? Int,
                secondaryButtonBorderColor = it["secondaryButtonBorderBackgrounColor"] as? Int,
                disableButtonBackgroundColor = it["disableButtonBackgrounColor"] as? Int,
                disableButtonTitleColor = it["disableButtonTitleBackgrounColor"] as? Int,
                checkboxColor = it["checkboxColor"] as? Int,
            )
        }

        Result.success(
            AppConfigModel(
                apiKey = apiKey,
                yunoConfiguration = yunoConfiguration,
                appearance = appearance,
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