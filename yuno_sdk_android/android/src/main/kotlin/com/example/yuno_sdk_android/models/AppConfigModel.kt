package com.example.yuno_sdk_android.models

data class AppConfigModel(
    val apiKey: String,
    val configuration: Configuration
)

fun Map<String, Any>.toApiConfig(): Result<AppConfigModel> {
    return try {
        // Extracting and casting values
        val apiKey = this["apiKey"] as? String
            ?: return Result.failure(IllegalArgumentException("Missing or invalid apiKey"))

        val configurationMap = this["configuration"] as? Map<*, *> ?: return Result.failure(
            IllegalArgumentException("Missing or invalid configuration")
        )
        val cardflow = try {
            CardFlow.valueOf(
                configurationMap["cardFlow"] as? String
                    ?: throw IllegalArgumentException("Missing or invalid cardflow")
            )
        } catch (e: IllegalArgumentException) {
            return Result.failure(e)
        }
        val saveCardEnable =
            configurationMap["saveCardEnable"] as? Boolean ?: return Result.failure(
                IllegalArgumentException("Missing or invalid saveCardEnable")
            )
        val keepLoader = configurationMap["keepLoader"] as? Boolean ?: return Result.failure(
            IllegalArgumentException("Missing or invalid keepLoader")
        )
        val isDynamicViewEnable =
            configurationMap["isDynamicViewEnable"] as? Boolean ?: return Result.failure(
                IllegalArgumentException("Missing or invalid isDynamicViewEnable")
            )
        val cardFormDeployed =
            configurationMap["cardFormDeployed"] as? Boolean ?: return Result.failure(
                IllegalArgumentException("Missing or invalid cardFormDeployed")
            )

        val configuration = Configuration(
            cardFlow = cardflow,
            saveCardEnable = saveCardEnable,
            keepLoader = keepLoader,
            isDynamicViewEnable = isDynamicViewEnable,
            cardFormDeployed = cardFormDeployed
        )
        Result.success(
            AppConfigModel(
                apiKey = apiKey,
                configuration = configuration
            )
        )

    } catch (e: Exception) {
        Result.failure(e)
    }
}