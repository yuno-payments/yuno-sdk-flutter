package com.example.yuno_sdk_android.models

enum class CardFlow {
    oneStep, multiStep
}

data class Configuration(
    val cardFlow: CardFlow,
    val saveCardEnable: Boolean,
    val keepLoader: Boolean,
    val isDynamicViewEnable: Boolean,
    val cardFormDeployed: Boolean
)