# Yuno SDK Flutter

<p align="center">
<img alt="Yuno Flutter SDK" loading="lazy" src="https://files.readme.io/2e1d03a6eec5051a64763f36225454778d7125c344f1d741d0c01cfcdafe4186-flutter-image.png" title="" height="auto" width="auto">
</p>

<div align="center">
  <a href="https://github.com/invertase/melos">
    <img alt="melos" src="https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=for-the-badge">
  </a>
  <a href="https://www.y.uno/">
    <img alt="Maintained by Yuno" src="https://img.shields.io/badge/maintained_by-Yuno-4E3DD8?style=for-the-badge">
  </a>
  <a href="https://opensource.org/licenses/MIT">
    <img src="https://img.shields.io/badge/license-MIT-purple.svg?style=for-the-badge" alt="License: MIT">
  </a>
</div>

<br>

> **⚠️ Open Source Project Notice**
> 
> This is an open source project related to YUNO. Support is provided by the community, not by YUNO directly. For community support, please open an issue in this repository.

This repository contains the Yuno Flutter SDK, which enables seamless payment integration in Flutter applications for both Android and iOS platforms.

## 📦 Packages

This monorepo contains the following packages:

| Package | Description | Version |
|---------|-------------|---------|
| [`yuno_sdk`](./yuno_sdk) | Main Flutter SDK package | [![pub package](https://img.shields.io/pub/v/yuno.svg)](https://pub.dev/packages/yuno) |
| [`yuno_sdk_android`](./yuno_sdk_android) | Android platform implementation | - |
| [`yuno_sdk_foundation`](./yuno_sdk_foundation) | iOS platform implementation | - |
| [`yuno_sdk_core`](./yuno_sdk_core) | Core shared functionality | - |
| [`yuno_sdk_platform_interface`](./yuno_sdk_platform_interface) | Platform interface definitions | - |

## 📚 Documentation

For detailed usage instructions, please refer to the [main SDK README](./yuno_sdk/README.md) or visit our [official documentation](https://docs.y.uno/).

## 🚀 Getting Started

### Installation

Add the Yuno SDK to your Flutter project:

```sh
flutter pub add yuno
```

For complete setup instructions, including Android and iOS configuration, please see the [main SDK README](./yuno_sdk/README.md).

## 🔧 Development Setup

This project uses [melos](https://github.com/invertase/melos) to manage all packages in this monorepo.

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Melos package manager

### Setup

1. **Install Melos**:
```sh
dart pub global activate melos
```

2. **Bootstrap the project**:
```sh
melos bootstrap
```

This will install all dependencies and link packages together.

### Useful Commands

| Command | Description |
|---------|-------------|
| `melos run format` | Format all Dart files |
| `melos run analyze` | Analyze all packages |
| `melos run test` | Run all tests |
| `melos run coverage` | Generate test coverage |
| `melos run get` | Run pub get in all packages |

## 🔄 Updating Native SDK Versions

The Yuno Flutter SDK wraps native Android and iOS SDKs. If you need to update the underlying native SDK versions, follow these steps:

### Android Native SDK

To update the Android native SDK version:

1. Navigate to `yuno_sdk_android/android/build.gradle`
2. Update the Yuno Android SDK version in the dependencies section:
```gradle
dependencies {
    implementation 'com.yuno.payments:yuno-sdk-android:x.x.x'
}
```
3. Sync the project and verify the integration works correctly
4. Update the `CHANGELOG.md` to reflect the native SDK version change

### iOS Native SDK

To update the iOS native SDK version:

1. Navigate to `yuno_sdk_foundation/ios/yuno_sdk_foundation.podspec`
2. Update the Yuno iOS SDK version in the dependencies section:
```ruby
s.dependency 'YunoSDK', 'x.x.x'
```
3. Run `pod install` in the example project to verify the integration
4. Update the `CHANGELOG.md` to reflect the native SDK version change

## 📝 Contributing

We welcome contributions to the Yuno Flutter SDK! Here's how you can help:

### Contribution Process

1. **Fork the repository** and create your feature branch
2. **Make your changes** following our coding standards
3. **Test thoroughly** - ensure all tests pass with `melos run test`
4. **Update documentation** - including CHANGELOG.md and any relevant README files
5. **Submit a Pull Request** with a clear description of your changes

### Code Quality Standards

- Follow Dart style guidelines
- Ensure all tests pass
- Maintain or improve code coverage
- Update documentation as needed

## 🚢 Publishing a New Version

After updating the native SDK versions or making any changes to the Flutter SDK:

1. **Create a Pull Request**: Submit a PR with your changes to the repository
2. **Include Documentation**: Make sure to update:
   - The relevant `CHANGELOG.md` file(s)
   - Any documentation affected by your changes
   - Version numbers if applicable

3. **Contact the Yuno Team**: Once your PR is ready:
   - Request a review from the Yuno team
   - The Yuno team will review, approve, and merge your changes
   - The Yuno team will handle the publication of the new SDK version to pub.dev

> **⚠️ Important**: Only the Yuno team has permissions to publish new versions of the SDK to pub.dev. Contributors should not attempt to publish versions independently.

### Version Management

This project uses melos for version management:

```sh
# Update versions
melos version

# Publish packages (Yuno team only)
melos publish
```

## 🏗️ Project Structure

```
yuno-sdk-flutter/
├── yuno_sdk/                      # Main Flutter SDK package
├── yuno_sdk_android/              # Android platform-specific code
├── yuno_sdk_foundation/           # iOS platform-specific code
├── yuno_sdk_core/                 # Core shared functionality
├── yuno_sdk_platform_interface/   # Platform interface definitions
├── example/                       # Example Flutter app
├── melos.yaml                     # Melos configuration
└── README.md                      # This file
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](./yuno_sdk/LICENSE) file for details.

## 🔗 Links

- [Yuno Website](https://www.y.uno/)
- [Official Documentation](https://docs.y.uno/)
- [pub.dev Package](https://pub.dev/packages/yuno)
- [Example Integration](https://github.com/yuno-payments/yuno-flutter-example)

## 💬 Support

For issues, questions, or contributions, please open an issue in this repository or contact the Yuno team.

---

<div align="center">
Made with ❤️ by the Yuno Team
</div>

