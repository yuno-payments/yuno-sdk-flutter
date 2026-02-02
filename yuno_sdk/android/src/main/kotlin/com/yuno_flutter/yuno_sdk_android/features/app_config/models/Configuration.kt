package com.yuno_flutter.yuno_sdk_android.features.app_config.models
import com.yuno.presentation.core.card.CardFormType


enum class CardFlow {
    oneStep, multiStep
}

fun CardFlow.toCardFLowSDK(): CardFormType {
    return when (this) {
        CardFlow.oneStep -> CardFormType.ONE_STEP
        CardFlow.multiStep -> CardFormType.STEP_BY_STEP
    }
}