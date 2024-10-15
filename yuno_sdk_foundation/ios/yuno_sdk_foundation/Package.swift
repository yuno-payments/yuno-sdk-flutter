    // swift-tools-version: 5.9
    // The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    // TODO: Update your plugin name.
    name: "yuno_sdk_foundation",
    platforms: [
        .iOS("14.0"),
    ],
    products: [
        .library(name: "yuno-sdk-foundation", type: .static ,targets: ["yuno_sdk_foundation"])
    ],
    dependencies: [
        .package(url: "https://github.com/yuno-payments/yuno-sdk-ios.git", from: "1.16.0")
    ],
    targets: [
        .target(
            name: "yuno_sdk_foundation",
            dependencies: [
                .product(name: "YunoSDK", package: "yuno-sdk-ios"),
            ],
            path: "Sources/yuno_sdk_foundation",
            sources: [
                "YunoMethods/Core",
                "YunoMethods/Models",
                "YunoMethods/Views",
                "YunoMethods/YunoMethods.swift",
                "YunoSdkFoundationPlugin.swift"
            ], resources: [
                .process("Resources/PrivacyInfo.xcprivacy"),
            ],
            cSettings: [
                .headerSearchPath("include/YunoSdkFoundationPlugin")
            ]
        ),
    ]
)
