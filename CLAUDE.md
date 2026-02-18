# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is the **Yuno Flutter SDK** monorepo, which provides seamless payment integration for Flutter applications on Android and iOS. The SDK wraps native Yuno Android and iOS SDKs behind Flutter platform channels, exposing a unified Dart API with pre-built widgets for payment flows, enrollment, and payment method selection.

The project is managed with [Melos](https://melos.invertase.dev/) and follows Flutter's federated plugin architecture, splitting platform-specific code into separate packages. The main package published to pub.dev is `yuno` (from the `yuno_sdk/` directory).

## Essential Commands

### Setup

```bash
# Install Melos globally
dart pub global activate melos

# Bootstrap the monorepo (installs deps, links local packages)
melos bootstrap

# Or use the setup script
./setup_local.sh
```

### Testing

```bash
# Run tests across all packages (excludes yuno_sdk_android and yuno_sdk_foundation)
melos run test

# Run tests with coverage + HTML report (macOS opens it automatically)
melos run test

# Run tests for a specific package
cd yuno_sdk && flutter test
cd yuno_sdk_core && flutter test
cd yuno_sdk_platform_interface && flutter test

# Run Bitrise CI tests (coverage only, no HTML report)
melos run bitrise_test
```

### Linting & Code Quality

```bash
# Analyze all packages
melos run analyze

# Format all Dart files
melos run format

# Single-package analysis
cd yuno_sdk && flutter analyze
```

### Building & Running the Example App

```bash
cd example
flutter pub get

# Run on iOS
flutter run -d ios

# Run on Android
flutter run -d android

# Run with environment variables
flutter run --dart-define-from-file=.env
```

### Dependency Management

```bash
# Get dependencies across all packages
melos run get

# Clean all packages
melos clean

# Version management (Yuno team only)
melos version
melos publish
```

## Architecture Overview

### Directory Structure

```
yuno-sdk-flutter/
├── yuno_sdk/                        # Main SDK package (published as "yuno" on pub.dev)
│   ├── lib/
│   │   ├── yuno.dart                # Library entry point
│   │   └── src/
│   │       ├── channels/            # Yuno class - main public API (init, payments, enrollment)
│   │       └── widgets/             # Flutter widgets (listeners, payment methods view)
│   └── test/
├── yuno_sdk_platform_interface/     # Platform interface definitions (abstract contracts)
│   ├── lib/src/
│   │   ├── yuno_interface_platform.dart   # YunoPlatform abstract interface
│   │   ├── yuno_method_channel.dart       # MethodChannel-based implementation
│   │   ├── features/               # Feature-specific models and parsers
│   │   │   ├── init/               # SDK initialization config models
│   │   │   ├── start_payment/      # Full payment flow models
│   │   │   ├── start_payment_lite/ # Lite payment flow models
│   │   │   ├── enrollment_payments/# Enrollment flow models
│   │   │   ├── seamless/           # Seamless payment models
│   │   │   └── show_payment_methods/ # Payment method display platform view
│   │   └── utils/                  # Notifiers (ValueNotifier-based state management)
│   └── test/
├── yuno_sdk_core/                   # Shared core types (enums, errors)
│   ├── lib/commons/src/
│   │   ├── enums/                   # YunoStatus, YunoLanguage
│   │   └── errors.dart              # YunoException sealed class hierarchy
│   └── test/
├── yuno_sdk_android/                # Android platform implementation
│   ├── lib/                         # Dart-side plugin registration (empty)
│   └── android/src/main/kotlin/     # Kotlin native code
│       └── com/yuno_flutter/yuno_sdk_android/
│           ├── YunoSdkAndroidPlugin.kt  # Main Android plugin entry point
│           ├── features/            # Feature handlers (init, payment, enrollment, etc.)
│           └── core/                # Config, keys, status converters
├── yuno_sdk_foundation/             # iOS platform implementation
│   ├── lib/                         # Dart-side (minimal)
│   └── ios/Classes/                 # Swift native code
│       ├── YunoSdkFoundationPlugin.swift  # Main iOS plugin entry point
│       └── YunoMethods/            # iOS method implementations and models
├── example/                         # Example Flutter app demonstrating SDK usage
├── yuno-flutter-qa-app/             # QA testing app (multi-platform)
├── melos.yaml                       # Melos monorepo configuration
├── setup_local.sh                   # Local development setup script
└── LOCAL_DEVELOPMENT.md             # Detailed local development guide
```

### Key Components

**Federated Plugin Architecture**: The SDK follows Flutter's [federated plugin pattern](https://docs.flutter.dev/packages-and-plugins/developing-packages#federated-plugins):
- `yuno_sdk` - App-facing package that developers depend on
- `yuno_sdk_platform_interface` - Abstract contracts and MethodChannel implementation
- `yuno_sdk_android` - Android-specific native code (Kotlin)
- `yuno_sdk_foundation` - iOS-specific native code (Swift)
- `yuno_sdk_core` - Shared types used across all packages

**Platform Communication**: Uses Flutter `MethodChannel('yuno/payments')` for Dart-to-native communication. Native-to-Dart callbacks flow through the same channel for OTT tokens (`ott`), payment status (`status`), and enrollment status (`enrollmentStatus`).

**Payment Method Views**: Uses platform views (`UiKitView` on iOS, `PlatformViewLink` on Android) to embed native payment method selection UI directly in the Flutter widget tree.

### Public API Entry Points

The `Yuno` class (in `yuno_sdk/lib/src/channels/yuno_channels.dart`) is the primary API:
- `Yuno.init()` - Initialize SDK with API key, country code, and configuration
- `Yuno.startPayment()` - Start full payment flow
- `Yuno.startPaymentLite()` - Start lightweight payment with specific method
- `Yuno.startPaymentSeamlessLite()` - Start seamless payment, returns `YunoStatus`
- `Yuno.enrollmentPayment()` - Card enrollment flow
- `Yuno.continuePayment()` - Resume a paused payment
- `Yuno.receiveDeeplink()` - Handle deep links (iOS only)
- `Yuno.hideLoader()` - Dismiss SDK loading indicator

**Widgets**:
- `YunoPaymentMethods` - Embeds native payment method selection view
- `YunoPaymentListener` - Listens for payment state changes (token + status)
- `YunoEnrollmentListener` - Listens for enrollment state changes
- `YunoMultiListener` - Combined payment + enrollment listener

**BuildContext extensions** (`YunoReader`): Sugar syntax providing `context.startPayment()`, `context.startPaymentLite()`, etc.

## Key Patterns

- **State Management**: Uses `ValueNotifier`-based notifiers (`YunoPaymentNotifier`, `YunoEnrollmentNotifier`, `YunoPaymentMethodSelectNotifier`) rather than external state management packages.
- **Sealed Exception Hierarchy**: `YunoException` is a sealed class with variants: `YunoUnexpectedException`, `YunoMethodNotImplemented`, `YunoTimeout`, `YunoMissingParam`, `YunoInvalidArguments`, `YunoNotFoundError`, `YunoNotSupport`.
- **Feature-based Organization**: Both Dart and native code are organized by feature (init, start_payment, start_payment_lite, enrollment, seamless, show_payment_methods).
- **Parser Pattern**: Each feature has `parsers.dart` files with static `toMap()` methods that convert Dart models to `Map<String, dynamic>` for MethodChannel serialization.
- **Factory Pattern**: `YunoMethodChannelFactory` creates the default platform implementation. `YunoPaymentMethodChannelFactory` creates platform view channel instances.
- **Local vs Published Dependencies**: Each package's `pubspec.yaml` has commented-out `path:` dependencies for local development. Melos handles linking during development via `melos bootstrap`.
- **Android Platform View Rendering**: `YunoPaymentMethods` supports two Android rendering modes via `AndroidPlatformViewRenderType`: `androidView` (GL texture, default) and `expensiveAndroidView` (view hierarchy, more compatible with older devices).
- **Testing Exclusions**: Test scripts in `melos.yaml` exclude `yuno_sdk_android` and `yuno_sdk_foundation` since those are native-only packages. Unit tests focus on `yuno_sdk`, `yuno_sdk_core`, and `yuno_sdk_platform_interface`.

## Dependencies

### Runtime Dependencies
- `flutter` SDK (>= 3.3.0)
- `plugin_platform_interface: ^2.1.8` - Flutter's platform interface verification
- Native Android SDK: `com.yuno.payments:android-sdk:2.10.0` (via JFrog Artifactory)
- Native iOS SDK: `YunoSDK 2.11.3` (via CocoaPods)

### Dev Dependencies
- `melos: ^6.2.0` - Monorepo management
- `flutter_lints: ^3.0.0` - Lint rules (uses `package:flutter_lints/flutter.yaml`)
- `mocktail: ^1.0.2` - Mocking for tests
- `dartdoc: ^8.0.13` - Documentation generation (in yuno_sdk only)

### Environment
- Dart SDK: `>=3.6.0 <4.0.0`
- Flutter SDK: `>=3.3.0`
- Android: minSdk 21, compileSdk 34, Kotlin 1.9.25 (supports Kotlin 2.x with Compose Compiler plugin)
- iOS: minimum deployment target 14.0, Swift 5.0

## Important Notes

- **Android Setup Requirement**: Android apps must use `FlutterFragmentActivity` (not `FlutterActivity`) and initialize the SDK in a custom `Application` class via `YunoSdkAndroidPlugin.initSdk(this, "API_KEY")`.
- **Android Maven Repository**: The Android build requires the Yuno JFrog Artifactory repository: `maven { url "https://yunopayments.jfrog.io/artifactory/snapshots-libs-release" }` in the project-level `build.gradle`.
- **Publishing**: Only the Yuno team can publish to pub.dev. Use `melos version` and `melos publish`.
- **Native SDK Updates**: Android version is in `yuno_sdk_android/android/build.gradle` (dependency line). iOS version is in `yuno_sdk_foundation/ios/yuno_sdk_foundation.podspec` (`s.dependency 'YunoSDK'`).
- **Environment Variables**: The example app reads `YUNO_API_KEY`, `YUNO_COUNTRY_CODE`, and `YUNO_CHECKOUT_SESSION` via `--dart-define` or `--dart-define-from-file=.env`.
- **Dependabot**: Configured for weekly pub dependency updates (excludes Flutter SDK itself).
- **Coverage Filtering**: Test coverage reports filter out generated files (`*.g.dart`, `generated/*.dart`).
