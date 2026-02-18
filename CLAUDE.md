# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

The Yuno Flutter SDK is a multi-package monorepo that enables seamless payment integration in Flutter applications for both Android and iOS platforms. It wraps the native Yuno Android and iOS SDKs using Flutter's federated plugin architecture, exposing Dart widgets and method channels to Flutter consumers. The public package is published to pub.dev as `yuno`.

The project is managed with [Melos](https://melos.invertase.dev/), which handles dependency linking, bootstrapping, and running scripts across all packages in the monorepo.

## Essential Commands

### Setup

```bash
# Install Melos globally
dart pub global activate melos

# Bootstrap the monorepo (install dependencies and link packages)
melos bootstrap

# Or use the setup script (also bootstraps and configures the example app)
./setup_local.sh
```

### Testing

```bash
# Run tests across all packages (excludes yuno_sdk_android and yuno_sdk_foundation)
melos run test

# Run tests for CI (no coverage filtering/HTML generation)
melos run bitrise_test

# Run tests for a single package
cd yuno_sdk && flutter test
cd yuno_sdk_core && flutter test

# Run tests with coverage and open HTML report (macOS)
melos run test
```

### Linting / Analysis

```bash
# Analyze all packages
melos run analyze

# Format all Dart files
melos run format
```

### Building / Running the Example App

```bash
# Get dependencies in all packages
melos run get

# Run the example app
cd example && flutter run -d ios
cd example && flutter run -d android

# Run with environment variables for credentials
cd example && flutter run --dart-define-from-file=.env
```

### Coverage Badge Generation

```bash
cd yuno_sdk && make coverage-badge
```

## Architecture Overview

### Directory Structure

```
yuno-sdk-flutter/
├── yuno_sdk/                      # Main Flutter SDK package (pub.dev: yuno)
│   ├── lib/src/channels/          # Method channel wrappers (YunoChannels)
│   ├── lib/src/widgets/           # Flutter widgets (YunoPaymentMethods, YunoPaymentListener, etc.)
│   └── test/                      # Unit tests
├── yuno_sdk_core/                 # Core shared functionality (enums, error types)
│   ├── lib/commons/               # Shared enums, errors, external types
│   └── test/
├── yuno_sdk_platform_interface/   # Platform interface definitions (abstract platform API)
│   ├── lib/src/features/          # Feature-specific interfaces (init, payment, enrollment, etc.)
│   ├── lib/src/utils/             # Utilities and notifiers
│   └── test/
├── yuno_sdk_android/              # Android platform implementation (Kotlin plugin)
│   ├── android/src/               # Kotlin source (YunoSdkAndroidPlugin)
│   ├── android/build.gradle       # Android native SDK dependency
│   └── lib/                       # Dart registration stub
├── yuno_sdk_foundation/           # iOS platform implementation (Swift plugin)
│   ├── ios/Classes/               # Swift source (YunoSdkFoundationPlugin)
│   ├── ios/yuno_sdk_foundation.podspec  # CocoaPods spec with YunoSDK dependency
│   └── lib/                       # Dart registration stub
├── example/                       # Example Flutter app for development/testing
├── yuno-flutter-qa-app/           # QA testing application
├── melos.yaml                     # Melos monorepo configuration
├── setup_local.sh                 # Local development setup script
└── LOCAL_DEVELOPMENT.md           # Local development guide
```

### Key Components

- **`yuno_sdk`** (package name: `yuno`): The main public-facing package. Exports widgets (`YunoPaymentMethods`, `YunoPaymentListener`, `YunoEnrollmentListener`, `YunoMultiListener`, `YunoReader`) and channel wrappers. This is what consumers install via `flutter pub add yuno`.
- **`yuno_sdk_core`**: Shared types including enums and error classes used across all packages.
- **`yuno_sdk_platform_interface`**: Defines the abstract platform interface (`YunoPlatform`, `YunoMethodChannel`) and feature-specific contracts (init, seamless payments, start_payment, start_payment_lite, enrollment, payment status, one_time_token, show_payment_methods).
- **`yuno_sdk_android`**: Android platform implementation using Kotlin. Wraps `com.yuno.payments:android-sdk` via Gradle. Plugin class: `YunoSdkAndroidPlugin`.
- **`yuno_sdk_foundation`**: iOS platform implementation using Swift. Wraps `YunoSDK` via CocoaPods. Plugin class: `YunoSdkFoundationPlugin`.

### Federated Plugin Pattern

The SDK follows Flutter's [federated plugin](https://docs.flutter.dev/packages-and-plugins/developing-packages#federated-plugins) architecture:

1. `yuno_sdk_platform_interface` defines the abstract API contract
2. `yuno_sdk_android` and `yuno_sdk_foundation` provide platform-specific implementations
3. `yuno_sdk` is the app-facing package that re-exports the public API and provides Flutter widgets

## Key Patterns

- **Monorepo managed by Melos**: All packages are linked locally during development via `melos bootstrap`. Dependency overrides are configured in `melos.yaml`.
- **Method channels**: Communication between Dart and native code uses Flutter method channels. The channel logic lives in `yuno_sdk/lib/src/channels/` and `yuno_sdk_platform_interface/lib/src/`.
- **Feature-based organization**: The platform interface organizes functionality into feature directories (init, seamless, start_payment, start_payment_lite, enrollment_payments, payment_status, one_time_token, show_payment_methods).
- **Selective exports**: The main `yuno_sdk` package selectively hides internal types (method channels, notifiers, parsers, state classes) from the public API using `hide` in export statements.
- **Analysis options**: All packages use `package:flutter_lints/flutter.yaml` as the lint baseline.
- **Tests exclude native packages**: The `melos run test` and `melos run bitrise_test` scripts skip `yuno_sdk_android` and `yuno_sdk_foundation` since those contain native code that cannot be unit-tested in Dart.
- **Testing uses mocktail**: Unit tests use the `mocktail` package for mocking.

## Dependencies

### Native SDK Versions

- **Android**: `com.yuno.payments:android-sdk:2.10.0` (configured in `yuno_sdk_android/android/build.gradle`)
- **iOS**: `YunoSDK 2.11.3` (configured in `yuno_sdk_foundation/ios/yuno_sdk_foundation.podspec`)

### Dart/Flutter Requirements

- Dart SDK: `>=3.6.0 <4.0.0`
- Flutter SDK: `>=3.3.0`
- iOS minimum deployment target: 14.0
- Android minimum SDK: 21, compile SDK: 34

### Key Dev Dependencies

- `melos: ^6.2.0` (monorepo management)
- `mocktail: ^1.0.2` (testing mocks)
- `flutter_lints: ^3.0.0` (lint rules)
- `plugin_platform_interface: ^2.1.8` (Flutter platform interface base)
- `dartdoc: ^8.0.13` (documentation generation)

## Important Notes

- **Default branch is `master`**, not `main`.
- **Publishing to pub.dev is restricted** to the Yuno team. Contributors should not attempt to publish independently.
- The Android plugin supports both Kotlin 1.x and 2.x, with automatic Compose Compiler plugin detection in `build.gradle`.
- The Android native code uses Jetpack Compose (`compose = true` in build features).
- For local development, `pubspec_overrides.yaml` files and path-based dependency overrides are used. Do not commit path-based overrides when publishing.
- Credentials for the example app are configured via `example/.env` or `example/lib/environments.dart`. Do not commit real API keys.
- The `yuno-flutter-qa-app/` directory contains an internal QA testing application separate from the `example/` app.
- Dependabot is configured for weekly pub ecosystem updates (`.github/dependabot.yml`).
- There are no CI workflow files (GitHub Actions); CI is handled externally (Bitrise, based on the `bitrise_test` melos script).
