# CLAUDE.md — Yuno Flutter SDK

## What is this repo?

Monorepo of the **Yuno Flutter SDK** (`yuno` on pub.dev). Wraps the Yuno native SDKs (Android + iOS) and exposes a single Dart API so Flutter apps can run native payment flows (card, APMs, enrollment, seamless, render, headless).

## Repo structure

```
yuno-sdk-flutter/
├── yuno_sdk/                         # Main package — published as "yuno" on pub.dev
│   ├── lib/src/
│   │   ├── channels/                 # Dart <-> native bridge
│   │   │   └── yuno_channels.dart    # `Yuno` public API + MethodChannel impl
│   │   ├── platform_interface/       # PlatformInterface abstraction + per-feature folders
│   │   │   ├── yuno_platform.dart    # Base abstract class
│   │   │   ├── yuno_method_channel.dart
│   │   │   ├── init/                 # <feature>/{<feature>.dart, models/, parsers.dart, keys/}
│   │   │   ├── start_payment/
│   │   │   ├── start_payment_lite/
│   │   │   ├── enrollment_payments/
│   │   │   ├── seamless/
│   │   │   └── show_payment_methods/
│   │   └── widgets/                  # YunoPaymentMethods, YunoPaymentListener, ...
│   ├── android/                      # Native Android plugin (Kotlin)
│   ├── ios/                          # Native iOS plugin (Swift)
│   └── test/                         # Unit + widget tests (mocktail)
├── example/                          # Minimal demo app
├── yuno-flutter-qa-app/              # Full-featured QA app (Riverpod + Firebase)
├── melos.yaml                        # Monorepo scripts
└── CHANGELOG.md                      # Release history
```

## Architecture

```
┌──────────────────────────────────────────┐
│  Merchant Flutter App                    │
└──────────────┬───────────────────────────┘
               │ Yuno.init(), Yuno.startPayment(), ...
               ▼
┌──────────────────────────────────────────┐
│  Public API (Yuno class)                 │  yuno_channels.dart
└──────────────┬───────────────────────────┘
               ▼
┌──────────────────────────────────────────┐
│  YunoPlatform (PlatformInterface)        │  yuno_platform.dart
│    └── YunoMethodChannel (default impl)  │
└──────────────┬───────────────────────────┘
               │ MethodChannel("yuno/payments")
               ▼
┌────────────────────────┬─────────────────┐
│  Android (Kotlin)      │  iOS (Swift)    │
│  YunoSdkAndroidPlugin  │  YunoSdkFoundationPlugin
│  + per-feature handlers│  + per-feature handlers
└────────────────────────┴─────────────────┘
```

Channel name: `"yuno/payments"`. Method keys (raw strings, must match across Dart/Kotlin/Swift):
`initialize`, `startPayment`, `startPaymentLite`, `continuePayment`, `enrollmentPayment`, `startPaymentSeamless`, `receiveDeeplink`, `hideLoader`, `showPaymentMethods`.

## Public API — what merchants use

- **`Yuno` class** (`lib/src/channels/yuno_channels.dart`):
  `init()`, `startPayment()`, `startPaymentLite()`, `enrollmentPayment()`, `continuePayment()`, `startPaymentSeamlessLite()`, `showPaymentMethods()`, `receiveDeeplink()`, `hideLoader()`.
- **Widgets** (`lib/src/widgets/`): `YunoPaymentMethods`, `YunoPaymentListener`, `YunoEnrollmentListener`, `YunoMultiListener`, `YunoReader`.
- **BuildContext extensions**: `context.startPayment(...)`, `context.startPaymentLite(...)`, etc.

## Native sync (the tricky part)

This SDK **wraps** the native SDKs — pinning is manual and lags slightly.

| Platform | Version pin | File |
|---|---|---|
| Android native | **2.13.4** | `yuno_sdk/android/build.gradle` (dep `"com.yuno.payments:android-sdk:2.13.4"`) |
| iOS native | **2.14.1** | `yuno_sdk/ios/yuno.podspec` (`s.dependency 'YunoSDK', '2.14.1'`) |

Companion repos (local dev):
- Android → `/Users/vlass/Documents/SDKS/yuno-android-sdk` (currently on `release/2.15.0`)
- iOS → `/Users/vlass/Documents/SDKS/yuno-ios`

**When bumping a native version:**
1. Bump the version string in `build.gradle` (Android) or `yuno.podspec` (iOS).
2. Run `melos bootstrap` to refresh the example and QA app pods.
3. Smoke-test both `example/` and `yuno-flutter-qa-app/` on each platform.
4. Add an entry to `CHANGELOG.md`.
5. Bump `pubspec.yaml` version.

## Per-feature file pattern (native handlers)

Every method channel method has 4 parallel implementations:

| Layer | Location | Example for `startPayment` |
|---|---|---|
| Dart public API | `lib/src/channels/yuno_channels.dart` | `Future<void> startPayment(...)` |
| Dart platform interface | `lib/src/platform_interface/start_payment/` | `start_payment.dart`, `models/start_payment_model.dart`, `models/parsers.dart`, `keys/` |
| Android handler | `yuno_sdk/android/src/main/kotlin/.../handlers/` | `StartPaymentHandler.kt` |
| iOS handler | `yuno_sdk/ios/Classes/` | `YunoMethods.swift` → `startPayment(...)`, model in `Models/StartPayment.swift` |

**Rule**: keys/model shape must stay in sync across all 4 layers. If you rename a key, grep the whole repo.

## Adding a new native method — step-by-step

1. **Define the key** as a constant in `lib/src/platform_interface/<feature>/keys/` (Dart).
2. **Define the model** (Dart data class + `toMap()/fromMap()` in `models/`).
3. **Expose in `YunoPlatform`** (abstract method) + implement in `YunoMethodChannel`.
4. **Add to public `Yuno` class** (`channels/yuno_channels.dart`) forwarding to `YunoPlatform.instance`.
5. **Android handler**: new file under `android/src/main/kotlin/.../handlers/`. Register in `YunoSdkAndroidPlugin.kt`'s `onMethodCall` dispatch.
6. **iOS handler**: add case in `YunoSdkFoundationPlugin.swift`'s method handler, implement in `YunoMethods.swift` or a new feature file.
7. **Unit test** in `yuno_sdk/test/` using `MockYunoPlatform` (see `test/mock_yuno_platform.dart`).
8. **Smoke-test** in `example/` and/or `yuno-flutter-qa-app/`.

## Dart conventions

- `analysis_options.yaml` uses `package:flutter_lints/flutter.yaml` (strict defaults).
- Null safety on (Dart `>=3.6.0 <4.0.0`, Flutter `>=3.3.0`).
- Every feature has: **handler + models + parsers + keys** as separate files.
- Platform-interface plugin: `plugin_platform_interface: ^2.1.8`.

### Code rules
- **No `!` force-unwraps** — use `??`, `?.`, early returns, or `ArgumentError` with context.
- **Never swallow errors** from native — surface via `PlatformException` → map to domain error.
- **Raw channel keys** (e.g., `"startPayment"`) must live in `keys/` files, not inlined.
- **Models are immutable** (`final` fields, `const` constructors where possible).
- **Prefer extension methods on `BuildContext`** for merchant-facing ergonomics.

## Tests

Located in `yuno_sdk/test/`. Stack: `flutter_test` + **mocktail**.

| File | Purpose |
|---|---|
| `yuno_channels_test.dart` | Method channel calls (happy path + errors) |
| `mock_yuno_platform.dart` | Mock implementation of `YunoPlatform` |
| `yuno_payment_listener_test.dart`, `yuno_enrollment_listener_test.dart`, `yuno_payment_methods_test.dart`, `yuno_multi_listener_test.dart` | Widget tests |

**Test policy:**
- DO test: method channel contracts, models (`toMap`/`fromMap`), parsers, widget public API.
- DON'T test: native internals (tested in the native repos), Flutter framework behavior.

## Melos scripts (`melos.yaml`)

```bash
melos bootstrap         # Install deps + link local packages
melos run test          # Run flutter test --coverage, generate HTML, open on macOS
melos run bitrise_test  # Same pipeline for CI
```

No built-in format/analyze scripts — run directly in the package:
```bash
cd yuno_sdk && dart format . && flutter analyze
```

## Example vs QA app

| App | Purpose |
|---|---|
| `example/` | Minimal demo (environments + main screen). Used for smoke tests and pub.dev example. |
| `yuno-flutter-qa-app/` | Full QA: Riverpod state, Firebase, country picker, color picker, shared preferences, app links. Used by QA team to exercise every integration mode. |

## Git / PRs / Release

- **Main branch**: `master` — PRs merge here.
- **PR template**: `.github/PULL_REQUEST_TEMPLATE.md` requires Purpose, Description, Related Issue, Checklist, Screenshots, Type (bug/feature/breaking/refactor/docs).
- **Commit style** (from recent history): plain-English descriptions, semver-aware. Example: `"update Android SDK to 2.13.4 and bump Flutter SDK to 1.0.12"`.
- **CI**: `.github/workflows/dependabot.yml` only (no custom CI workflow yet — tests run locally / via Melos).
- **Release**:
  1. Bump native versions (see "Native sync" above).
  2. Bump `yuno_sdk/pubspec.yaml` `version:`.
  3. Update `CHANGELOG.md`.
  4. Tag + push.
  5. `flutter pub publish` from `yuno_sdk/`.
  6. Verify at https://pub.dev/packages/yuno.

## Common pitfalls

- **Bumping native**: the `example/` Podfile and `yuno-flutter-qa-app/` might cache pods. After bumping iOS pod version, `cd example/ios && pod install --repo-update`.
- **Channel-key drift**: adding a method on Dart side but forgetting Android/iOS → silent `MissingPluginException` at runtime. Always ship all 4 layers in the same PR.
- **Android handler lifecycle**: `YunoSdkAndroidPlugin` implements `ActivityAware` + `DefaultLifecycleObserver`. Handlers that launch activities need the attached Activity reference — don't call from `onAttachedToEngine` directly.
- **iOS deeplinks**: must be routed via `Yuno.receiveDeeplink()` from the merchant's `AppDelegate` or the iOS payment flow hangs.

## Quick reference

| Task | Command / File |
|---|---|
| Bootstrap workspace | `melos bootstrap` |
| Run tests | `melos run test` |
| Format | `dart format yuno_sdk/` |
| Analyze | `cd yuno_sdk && flutter analyze` |
| Bump Android native | `yuno_sdk/android/build.gradle` line with `"com.yuno.payments:android-sdk:X.Y.Z"` |
| Bump iOS native | `yuno_sdk/ios/yuno.podspec` `s.dependency 'YunoSDK', 'X.Y.Z'` |
| Publish | `cd yuno_sdk && flutter pub publish` |

## Current versions (as of 2026-04-24)

- **Flutter SDK (this package)**: 1.0.12
- **Android native pinned**: 2.13.4
- **iOS native pinned**: 2.14.1
- **Dart**: `>=3.6.0 <4.0.0`
- **Flutter**: `>=3.3.0`
