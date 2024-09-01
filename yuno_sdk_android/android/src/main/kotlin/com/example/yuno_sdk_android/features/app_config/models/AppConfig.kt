package com.example.yuno_sdk_android.features.app_config.models

data class AppConfigModel(
    val apiKey: String,
    val countryCode: String,
    val yunoConfiguration: YunoConfiguration,
    val configuration: Configuration
)

data class YunoConfiguration(
    val cardFlow: CardFlow,
    val saveCardEnable: Boolean,
    val keepLoader: Boolean,
    val isDynamicViewEnable: Boolean
)

fun Map<String, Any>.toApiConfig(): Result<AppConfigModel> {
    return try {
        // Extracting and casting values
        val apiKey = this["apiKey"] as? String
            ?: return Result.failure(IllegalArgumentException("Missing or invalid apiKey"))

        val countryCode = this["countryCode"] as? String
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

        val configurationMap = this["configuration"] as? Map<*, *> ?: return Result.failure(
            IllegalArgumentException("Missing or invalid configuration")
        )

        val cardFormDeployed =
            configurationMap["cardFormDeployed"] as? Boolean ?: return Result.failure(
                IllegalArgumentException("Missing or invalid cardFormDeployed")
            )

        val yunoConfiguration = YunoConfiguration(
            cardFlow = cardflow,
            saveCardEnable = saveCardEnable,
            keepLoader = keepLoader,
            isDynamicViewEnable = isDynamicViewEnable,
        )
        val configuration = Configuration(
            cardFormDeployed = cardFormDeployed
        )
        Result.success(
            AppConfigModel(
                apiKey = apiKey,
                countryCode = countryCode,
                yunoConfiguration = yunoConfiguration,
                configuration = configuration
            )
        )

    } catch (e: Exception) {
        Result.failure(e)
    }
}