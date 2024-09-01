package com.example.yuno_sdk_android.features.app_config.models

data class AppConfigModel(
    val apiKey: String,
    val cardFlow: CardFlow,
    val saveCardEnable: Boolean,
    val keepLoader: Boolean,
    val isDynamicViewEnable: Boolean,
    val configuration: Configuration
)

fun Map<String, Any>.toApiConfig(): Result<AppConfigModel> {
    return try {
        // Extracting and casting values
        val apiKey = this["apiKey"] as? String
            ?: return Result.failure(IllegalArgumentException("Missing or invalid apiKey"))

        val cardflow = try {
            CardFlow.valueOf(
                this["cardFlow"] as? String
                    ?: throw IllegalArgumentException("Missing or invalid cardflow")
            )
        } catch (e: IllegalArgumentException) {
            return Result.failure(e)
        }
        val saveCardEnable =
            this["saveCardEnable"] as? Boolean ?: return Result.failure(
                IllegalArgumentException("Missing or invalid saveCardEnable")
            )
        val keepLoader = this["keepLoader"] as? Boolean ?: return Result.failure(
            IllegalArgumentException("Missing or invalid keepLoader")
        )
        val isDynamicViewEnable =
            this["isDynamicViewEnable"] as? Boolean ?: return Result.failure(
                IllegalArgumentException("Missing or invalid isDynamicViewEnable")
            )
        val configurationMap = this["configuration"] as? Map<*, *> ?: return Result.failure(
            IllegalArgumentException("Missing or invalid configuration")
        )

        val cardFormDeployed =
            configurationMap["cardFormDeployed"] as? Boolean ?: return Result.failure(
                IllegalArgumentException("Missing or invalid cardFormDeployed")
            )

        val configuration = Configuration(

            cardFormDeployed = cardFormDeployed
        )
        Result.success(
            AppConfigModel(
                apiKey = apiKey,
                cardFlow = cardflow,
                saveCardEnable = saveCardEnable,
                keepLoader = keepLoader,
                isDynamicViewEnable = isDynamicViewEnable,
                configuration = configuration
            )
        )

    } catch (e: Exception) {
        Result.failure(e)
    }
}