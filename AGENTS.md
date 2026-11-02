# AGENTS.md — Yuno Flutter SDK

Instructions for every engineer and coding agent (any model) working in this repository. `CLAUDE.md` imports this file; keep all guidance here.

## What is this repo?

Monorepo of the **Yuno Flutter SDK** (`yuno` on pub.dev). It is a thin wrapper: it exposes a single Dart API over a `MethodChannel` that calls the Yuno native SDKs (Android + iOS), so Flutter apps can run native payment flows (card, APMs, enrollment, seamless, render, headless). There is no Flutter-side payment logic or payment UI; almost every feature and bug lives in the native SDKs.

The repo is public (MIT). Everything you commit is visible to merchants.

## Repo structure

```
yuno-sdk-flutter/
├── yuno_sdk/                                  # Main package — published as "yuno" on pub.dev
│   ├── lib/yuno.dart                          # Library entry point (`package:yuno/yuno.dart`)
│   ├── lib/src/
│   │   ├── channels/
│   │   │   └── yuno_channels.dart             # `Yuno` public API (static methods) + `_YunoChannels`
│   │   ├── core/                              # Enums (YunoStatus, YunoLanguage), errors, YunoStatusMessage
│   │   ├── platform_interface/
│   │   │   ├── yuno_interface_platform.dart   # `YunoPlatform` (PlatformInterface) base class
│   │   │   ├── yuno_method_channel.dart       # `YunoMethodChannel` default impl, MethodChannel("yuno/payments")
│   │   │   ├── utils/                         # Notifiers (payment, enrollment, method selection), singleton
│   │   │   └── features/                      # One folder per feature: <feature>.dart, models/ (model + parsers), keys/ where present
│   │   │       ├── init/
│   │   │       ├── start_payment/
│   │   │       ├── start_payment_lite/
│   │   │       ├── enrollment_payments/
│   │   │       ├── seamless/
│   │   │       ├── show_payment_methods/      # Platform view "yuno/payment_methods_view"
│   │   │       ├── one_time_token/keys/
│   │   │       └── payment_status/keys/
│   │   └── widgets/                           # YunoPaymentMethods, YunoPaymentListener, YunoEnrollmentListener, YunoMultiListener, YunoReader
│   ├── android/                               # Native Android plugin (Kotlin), one handler per feature
│   ├── ios/                                   # Native iOS plugin (Swift), yuno.podspec
│   ├── test/src/                              # Unit + widget tests (flutter_test + mocktail)
│   └── CHANGELOG.md                           # Package changelog, published on pub.dev
├── example/                                   # Minimal demo app (also the pub.dev example)
├── yuno-flutter-qa-app/                       # Full-featured QA app (Riverpod + Firebase)
├── melos.yaml                                 # Monorepo scripts (manages ./yuno_sdk only)
├── pubspec.yaml                               # Workspace pubspec (melos dev dependency)
├── Dangerfile                                 # PR check: yuno_sdk/CHANGELOG.md must be modified
├── setup_local.sh / LOCAL_DEVELOPMENT.md      # Local setup helpers
└── .github/                                   # PULL_REQUEST_TEMPLATE.md, dependabot.yml
```

## Architecture

```
┌──────────────────────────────────────────┐
│  Merchant Flutter App                    │
└──────────────┬───────────────────────────┘
               │ Yuno.init(), Yuno.startPayment(), ...
               ▼
┌──────────────────────────────────────────┐
│  Public API (Yuno class)                 │  channels/yuno_channels.dart
└──────────────┬───────────────────────────┘
               ▼
┌──────────────────────────────────────────┐
│  YunoPlatform (PlatformInterface)        │  platform_interface/yuno_interface_platform.dart
│    └── YunoMethodChannel (default impl)  │  platform_interface/yuno_method_channel.dart
└──────────────┬───────────────────────────┘
               │ MethodChannel("yuno/payments")
               ▼
┌────────────────────────┬──────────────────────────┐
│  Android (Kotlin)      │  iOS (Swift)             │
│  YunoSdkAndroidPlugin  │  YunoSdkFoundationPlugin │
│  + per-feature handlers│  + YunoMethods           │
└────────────────────────┴──────────────────────────┘
```

Channel name: `"yuno/payments"`. Dart → native method keys (raw strings, must match across Dart/Kotlin/Swift):
`initialize`, `startPayment`, `startPaymentLite`, `continuePayment`, `enrollmentPayment`, `startPaymentSeamless`, `receiveDeeplink`, `hideLoader`.

- Native → Dart callbacks on the same channel: `ott`, `status`, `enrollmentStatus` (with `message` / `substatus` detail).
- Payment-method list is a **platform view**, not a channel method: view type `yuno/payment_methods_view`, per-view channel `yuno/payment_methods_view/<viewId>` with `onSelected` and `onHeightChange`.
- `hideLoader` is handled on iOS only; Android has no `hideLoader` branch and answers `notImplemented`.
- Key constants per platform: Android `android/src/main/kotlin/.../core/utils/keys/Key.kt`, iOS `ios/Classes/YunoMethods/Core/Commons/Enums/Keys.swift`. On the Dart side the method keys are currently inlined in `yuno_method_channel.dart`; only `one_time_token/keys/` and `payment_status/keys/` exist as key files.

## Public API — what merchants use

- **`Yuno` class** (`lib/src/channels/yuno_channels.dart`), all static:
  `init()`, `startPayment()`, `startPaymentLite()`, `enrollmentPayment()`, `continuePayment()`, `startPaymentSeamlessLite()`, `receiveDeeplink()`, `hideLoader()`.
- **Widgets** (`lib/src/widgets/`): `YunoPaymentMethods` (renders the native payment-method list), `YunoPaymentListener`, `YunoEnrollmentListener`, `YunoMultiListener`.
- **BuildContext extensions** (`YunoReader`, `widgets/yuno_reader.dart`): `context.startPayment(...)`, `context.startPaymentLite(...)`, etc.

## Native sync (the tricky part)

This SDK **wraps** the native SDKs — pinning is manual and lags slightly.

Pinned versions live only in these files; read them there rather than copying them into docs:

| What | Source of truth |
|---|---|
| Android native | `yuno_sdk/android/build.gradle` (dependency `"com.yuno.payments:android-sdk:X.Y.Z"`) |
| iOS native | `yuno_sdk/ios/yuno.podspec` (`s.dependency 'YunoSDK', 'X.Y.Z'`) |
| This package | `yuno_sdk/pubspec.yaml` (`version:`) |

Companion repos: the native Android SDK and the native iOS SDK (`yuno-payments` org). Clone them next to this repo when you need to debug native behaviour.

**When bumping a native version:**
1. Bump the version string in `build.gradle` (Android) or `yuno.podspec` (iOS).
2. Run `melos bootstrap`, then refresh pods: `cd example/ios && pod install --repo-update` (same in the QA app's `ios/`).
3. Smoke-test both `example/` and `yuno-flutter-qa-app/` on each platform.
4. Add an entry to `yuno_sdk/CHANGELOG.md`.
5. Bump `version:` in `yuno_sdk/pubspec.yaml`.

## Per-feature file pattern (the four layers)

Every method channel method has 4 parallel implementations:

| Layer | Location | Example for `startPayment` |
|---|---|---|
| Dart public API | `lib/src/channels/yuno_channels.dart` | `static Future<void> startPayment(...)` |
| Dart platform interface | `lib/src/platform_interface/features/start_payment/` + `yuno_interface_platform.dart` / `yuno_method_channel.dart` | `start_payment.dart`, `models/start_payment_model.dart`, `models/parsers.dart` |
| Android handler | `yuno_sdk/android/src/main/kotlin/com/yuno_flutter/yuno_sdk_android/features/<feature>/method_channel/` | `start_payment/method_channel/StartPaymentHandler.kt` |
| iOS handler | `yuno_sdk/ios/Classes/` | `YunoSdkFoundationPlugin.swift` dispatch → `YunoMethods/YunoMethods.swift`, model in `YunoMethods/Models/StartPayment.swift` |

**Rule**: keys/model shape must stay in sync across all 4 layers. If you rename a key, grep the whole repo.

## Adding a new native method — step-by-step

1. **Define the key** as a constant in `lib/src/platform_interface/features/<feature>/keys/` (Dart), plus `Key.kt` (Android) and `Keys.swift` (iOS).
2. **Define the model** (Dart data class + `toMap()/fromMap()` in `models/`).
3. **Expose in `YunoPlatform`** (abstract method in `yuno_interface_platform.dart`) + implement in `YunoMethodChannel`.
4. **Add to public `Yuno` class** (`channels/yuno_channels.dart`) forwarding to the platform instance.
5. **Android handler**: new file under `android/src/main/kotlin/.../features/<feature>/method_channel/`. Register it in `YunoSdkAndroidPlugin.kt`'s `onMethodCall` `when` dispatch.
6. **iOS handler**: add a case in `YunoSdkFoundationPlugin.swift`'s `switch call.method`, implement in `YunoMethods.swift` or a new feature file.
7. **Unit test** in `yuno_sdk/test/src/` using `MockYunoPlatform` (`test/src/utils/mock_yuno_platform.dart`).
8. **Smoke-test** in `example/` and/or `yuno-flutter-qa-app/`.

## Wrapper rules

- **Platform channels mirror the native SDKs.** The Dart API, its models and its keys follow the native SDK contracts; do not invent Flutter-only behaviour or payment logic. If a native SDK lacks something, it is fixed there first.
- **A channel change needs iOS and Android.** Any new, renamed or reshaped method, key or argument ships all four layers (Dart API, Dart platform interface, Android handler, iOS handler) in the same PR. A side left behind fails silently at runtime as `MissingPluginException` or a dropped field. If a method is intentionally single-platform (like `hideLoader`), document it here and in the dartdoc.
- **Reproduce in the native example app first.** If a bug reproduces there, it belongs in the native repo. If only Flutter fails, suspect the bridge: a key mismatch, an unmapped model field, or a callback cleared on init.
- **iOS deeplinks**: merchants must route them through `Yuno.receiveDeeplink()` from `AppDelegate`, or the iOS payment flow hangs.

## Dart conventions and clean code

- Follow [Effective Dart](https://dart.dev/effective-dart) (style, documentation, usage, design) and `package:flutter_lints/flutter.yaml` (`yuno_sdk/analysis_options.yaml`). Analyzer warnings fail CI.
- Null safety on (Dart `>=3.6.0 <4.0.0`, Flutter `>=3.3.0`, per `yuno_sdk/pubspec.yaml`).
- New features must have **handler + models + parsers + keys** as separate files. Existing features do not all follow this yet: most method keys are still inlined (known debt, see "Code rules").
- Platform-interface plugin: `plugin_platform_interface: ^2.1.8`.
- `abstract interface class` for public abstractions (`Yuno`, `YunoPlatform`), `final class` for internals.
- Public API is documented with dartdoc (`///`, `{@template}`); test-only accessors use `@visibleForTesting`.
- Small, single-purpose functions and classes; names state intent; no dead code and no copy-pasted logic.
- Format with `dart format`; do not reformat lines you are not otherwise changing.

### Code rules
- **No `!` force-unwraps** — use `??`, `?.`, early returns, or `ArgumentError` with context.
- **Never swallow errors** from native — surface via `PlatformException` → map to domain error.
- **Raw channel keys** (e.g., `"startPayment"`) belong in `keys/` files, not inlined. Existing inlined keys in `yuno_method_channel.dart` are known debt: move the ones you touch.
- **Models are immutable** (`final` fields, `const` constructors where possible).
- **Prefer extension methods on `BuildContext`** for merchant-facing ergonomics.

## How to test

Tests live in `yuno_sdk/test/src/`. Stack: `flutter_test` + **mocktail** (dev dependencies in `yuno_sdk/pubspec.yaml`).

```bash
# One-time setup from the repo root
dart pub global activate melos
melos bootstrap                  # or ./setup_local.sh (also creates example/.env)

# Unit + widget tests with coverage (what CI runs: melos run bitrise_test)
cd yuno_sdk && flutter test --coverage

# Same, plus an lcov-filtered HTML report (needs lcov/genhtml, e.g. `brew install lcov`; opens on macOS)
melos run test

# Static analysis and formatting (no melos script for these)
cd yuno_sdk && flutter analyze
dart format yuno_sdk/

# Publish dry-run (pub.dev package checks)
cd yuno_sdk && flutter pub publish --dry-run

# Example app (example/lib/environments.dart reads YUNO_API_KEY via String.fromEnvironment)
cd example && flutter run --dart-define=YUNO_API_KEY=<sandbox key>
```

Notes:
- `example/.env` is **tracked** in git and holds only the placeholder `YUNO_API_KEY=your_api_key_here`. Never put a real key in it. If you prefer a file, use an untracked copy (for example `example/.env.local` with `--dart-define-from-file=.env.local`) and check `git status` before committing.
- Native Android code has a single unit test (`yuno_sdk/android/src/test/kotlin/.../YunoSdkAndroidPluginTest.kt`). No Gradle wrapper script is committed in `yuno_sdk/android/` and CI does not run it; verify native changes through `example/` and `yuno-flutter-qa-app/` on a device.

| File | Purpose |
|---|---|
| `test/src/channels/yuno_channels_test.dart` | Method channel calls (happy path + errors) |
| `test/src/channels/yuno_status_message_test.dart` | `YunoStatusMessage` parsing |
| `test/src/utils/mock_yuno_platform.dart` | Mock implementation of `YunoPlatform` |
| `test/src/widgets/yuno_payment_listener_test.dart`, `yuno_enrollment_listener_test.dart`, `yuno_payment_methods_test.dart`, `yuno_multi_listener_test.dart`, `yuno_reader_test.dart` | Widget tests |

**Test policy:**
- DO test: method channel contracts, models (`toMap`/`fromMap`), parsers, widget public API.
- DON'T test: native internals (tested in the native repos), Flutter framework behavior.
- Every behaviour change gets a test; every bug fix gets a regression test that fails before the fix.
- Mocks: `class MockX extends Mock with MockPlatformInterfaceMixin implements YunoPlatform`; register fallback values in `setUpAll`; reset `debugDefaultTargetPlatformOverride = null` in `tearDown`.
- Never weaken or delete a failing test to go green.

## Example vs QA app

| App | Purpose |
|---|---|
| `example/` | Minimal demo (environments + main screen). Depends on `../yuno_sdk` by path. Used for smoke tests and pub.dev example. |
| `yuno-flutter-qa-app/` | Full QA: Riverpod state, Firebase, country picker, color picker, shared preferences, app links. Used by QA team to exercise every integration mode. |

## Git / PRs / Release

- **Main branch**: `master` — PRs merge here.
- **PR template**: `.github/PULL_REQUEST_TEMPLATE.md` — Purpose, Description, Related Issue, Checklist, Additional Information, Screenshots, Types of Changes, Reviewers. Fill every section; write N/A where one does not apply.
- **PRs are in English.**
- **Changelog**: Danger (`Dangerfile`) fails the PR unless `yuno_sdk/CHANGELOG.md` is modified. Entries go under the new version as `- feat: <user-facing description>` or `- fix: <user-facing description>`. The file is public on pub.dev: no ticket IDs, internal names or implementation details.
- **Commit style** (from recent history): plain-English descriptions, semver-aware. Example: `"feat(sdk): bump native SDKs (Android 2.22.0, iOS 2.23.1) and surface status detail"`.
- **CI**: Bitrise (configured outside this repo). The PR workflow runs the Danger changelog check, `dart analyze`, a publish dry-run and the tests. `.github/` holds only `dependabot.yml` (weekly pub updates) and the PR template; there is no GitHub Actions workflow.
- **Release**:
  1. Bump native versions (see "Native sync" above).
  2. Bump `yuno_sdk/pubspec.yaml` `version:`.
  3. Update `yuno_sdk/CHANGELOG.md`.
  4. Release branch `release-v<x.y.z>`, PR to `master`, then tag `v<x.y.z>` and push.
  5. Publish to pub.dev (`cd yuno_sdk && flutter pub publish`; the Bitrise deploy workflow runs on the tag).
  6. Verify at https://pub.dev/packages/yuno.

## PR scope rules

- **One concern per PR.** Change only what the task needs; no drive-by reformatting, import reordering or unrelated dependency/CI edits.
- **Improve what you touch.** Leave the code you change cleaner than you found it (fix a nearby lint, move an inlined key you edit into `keys/`, add a missing test for the path you modify), within the files the task already touches.
- **Refactors over 3 extra files go elsewhere.** If an improvement would touch more than 3 files beyond the task's own, do not include it: open a separate PR and an AnyForge work item for it, and mention it in the original PR.
- Channel changes always include both platforms (see "Wrapper rules"); that is scope, not an extra refactor.
- Keep this file and the README in sync with any change that makes them stale, in the same PR.

## Common pitfalls

- **Bumping native**: the `example/` Podfile and `yuno-flutter-qa-app/` might cache pods. After bumping iOS pod version, `cd example/ios && pod install --repo-update`.
- **Channel-key drift**: adding a method on Dart side but forgetting Android/iOS → silent `MissingPluginException` at runtime. Always ship all 4 layers in the same PR.
- **Android handler lifecycle**: `YunoSdkAndroidPlugin` implements `ActivityAware` + `DefaultLifecycleObserver` and requires a `FlutterFragmentActivity`. Handlers that launch activities need the attached Activity reference — don't call from `onAttachedToEngine` directly.
- **iOS deeplinks**: must be routed via `Yuno.receiveDeeplink()` from the merchant's `AppDelegate` or the iOS payment flow hangs.
- **Secrets**: never commit an API key. `example/.env` is tracked and must only ever hold the placeholder; pass real keys with `--dart-define` or an untracked file.

## Quick reference

| Task | Command / File |
|---|---|
| Bootstrap workspace | `melos bootstrap` |
| Run tests (CI) | `cd yuno_sdk && flutter test --coverage` (`melos run bitrise_test`) |
| Run tests + HTML report | `melos run test` |
| Format | `dart format yuno_sdk/` |
| Analyze | `cd yuno_sdk && flutter analyze` |
| Publish dry-run | `cd yuno_sdk && flutter pub publish --dry-run` |
| Bump Android native | `yuno_sdk/android/build.gradle` line with `"com.yuno.payments:android-sdk:X.Y.Z"` |
| Bump iOS native | `yuno_sdk/ios/yuno.podspec` `s.dependency 'YunoSDK', 'X.Y.Z'` |
| Publish | `cd yuno_sdk && flutter pub publish` |

## Supported toolchain

- **Dart / Flutter constraints**: `environment:` in `yuno_sdk/pubspec.yaml` (Dart `>=3.6.0 <4.0.0`, Flutter `>=3.3.0`).
- **Package and native versions**: read the files listed in "Native sync"; do not copy them here.
