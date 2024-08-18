package com.example.yuno_sdk_android.models

data class AppConfigModel(
    val apiKey: String,
    val countryCode: String,
    val configuration: Configuration
)

fun Map<String, Any>.toApiConfig(): Result<AppConfigModel> {
    return try {
        // Extracting and casting values
        val apiKey = this["apiKey"] as? String
            ?: return Result.failure(IllegalArgumentException("Missing or invalid apiKey"))
        val countryCode = this["countryCode"] as? String ?: return Result.failure(
            IllegalArgumentException("Missing or invalid countryCode")
        )

        val configurationMap = this["configuration"] as? Map<String, Any> ?: return Result.failure(
            IllegalArgumentException("Missing or invalid configuration")
        )
        val cardflow = try {
            CardFlow.valueOf(
                configurationMap["cardflow"] as? String
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

        // Creating configuration object
        val configuration = Configuration(
            cardFlow = cardflow,
            saveCardEnable = saveCardEnable,
            keepLoader = keepLoader,
            isDynamicViewEnable = isDynamicViewEnable,
            cardFormDeployed = cardFormDeployed
        )

        // Returning the ApiConfig object wrapped in Result.success
        Result.success(
            AppConfigModel(
                apiKey = apiKey,
                countryCode = countryCode,
                configuration = configuration
            )
        )

    } catch (e: Exception) {
        // Catching any unforeseen exceptions and returning a failure result
        Result.failure(e)
    }
}