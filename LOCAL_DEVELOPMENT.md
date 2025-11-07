# Local Development Guide - Yuno SDK Flutter

This document guides you through setting up and testing the Yuno SDK locally.

## 📋 Prerequisites

1. **Flutter SDK** (version 3.6.0 or higher)
   ```bash
   # Verify installation
   flutter --version
   flutter doctor
   ```

2. **Dart SDK** (included with Flutter)

3. **Xcode** (for iOS) or **Android Studio** (for Android)

## 🚀 Initial Setup

### 1. Install Melos (Monorepo Manager)

```bash
# Install Melos globally
dart pub global activate melos

# Verify installation
melos --version
```

### 2. Configure the Project

```bash
# Navigate to the project directory
cd /path/to/yuno-sdk-flutter

# Run the setup script
./setup_local.sh

# Or manually:
melos bootstrap
cd example
flutter pub get
```

### 3. Configure Credentials

Edit the `example/lib/environments.dart` file and replace the default values:

```dart
class Environments {
  static const apiKey = String.fromEnvironment(
    'YUNO_API_KEY',
    defaultValue: 'your_real_api_key_here', // ← Replace this
  );
  
  static const checkoutSession = String.fromEnvironment(
    'YUNO_CHECKOUT_SESSION',
    defaultValue: 'your_checkout_session_here', // ← Replace this
  );
}
```

**Or using environment variables:**

```bash
# Create .env file in the example/ directory
echo "YUNO_API_KEY=your_api_key_here" > example/.env
echo "YUNO_CHECKOUT_SESSION=your_checkout_session_here" >> example/.env

# Run with environment variables
cd example
flutter run --dart-define-from-file=.env
```

## 🏃‍♂️ Run the Example Application

### For iOS:
```bash
cd example
flutter run -d ios
```

### For Android:
```bash
cd example
flutter run -d android
```

## 🔧 SDK Development

### Project Structure

```
yuno-sdk-flutter/
├── yuno_sdk/                 # Main SDK
├── yuno_sdk_core/           # Core functionalities
├── yuno_sdk_android/        # Android implementation
├── yuno_sdk_foundation/     # iOS implementation
├── yuno_sdk_platform_interface/ # Platform interface
└── example/                 # Example application
```

### Useful Commands

```bash
# Bootstrap the monorepo (install dependencies)
melos bootstrap

# Run tests in all packages
melos test

# Clean all packages
melos clean

# Get dependencies in all packages
melos pub get

# Run code analysis
melos analyze
```

### Testing

```bash
# Unit tests
cd yuno_sdk
flutter test

# Integration tests
cd example
flutter test integration_test/

# Coverage
melos test  # Generates coverage report
```

## 📱 Available Features

The example application includes:

- **YunoPaymentMethods**: Widget to display payment methods
- **startPaymentLite()**: Start payment with specific method
- **startPayment()**: Start complete payment flow

## 🐛 Debugging

### SDK Logs

The SDK uses a custom logger. To view logs:

```bash
# On iOS
flutter logs --device-id=<ios-device-id>

# On Android
flutter logs --device-id=<android-device-id>
```

### Common Issues

1. **API Key Error**: Verify that the API key is valid
2. **Invalid Checkout Session**: Make sure to use an active checkout session
3. **Dependencies**: Run `melos bootstrap` if there are dependency issues

## 🔗 Useful Links

- [Yuno Documentation](https://docs.y.uno/)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Melos Documentation](https://melos.invertase.dev/)

