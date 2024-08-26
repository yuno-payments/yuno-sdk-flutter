package com.example.yuno_sdk_android.features.app_config.models
import com.yuno.payments.features.base.ui.screens.CardFormType


enum class CardFlow {
    oneStep, multiStep
}

fun CardFlow.toCardFLowSDK(): CardFormType {
    return when (this) {
        CardFlow.oneStep -> CardFormType.ONE_STEP
        CardFlow.multiStep -> CardFormType.MULTI_STEP
    }
}

data class Configuration(
    val cardFlow: CardFlow,
    val saveCardEnable: Boolean,
    val keepLoader: Boolean,
    val isDynamicViewEnable: Boolean,
    val cardFormDeployed: Boolean
)