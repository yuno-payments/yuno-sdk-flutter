# Yuno - Flutter
<?code-excerpt path-base="example/lib"?>

Yuno Flutter SDK empowers you to create seamless payment experiences in your native Android and iOS apps built with Flutter. It offers powerful and customizable UI components that can be used directly to gather payment details from your users efficiently and effectively.



|             | Android | iOS   | Linux | macOS  | Web | Windows     |
|-------------|---------|-------|-------|--------|-----|-------------|
| **Support** | SDK 16+ | 14.0+ | None   | None  | None| None        |

## Features

#### 1. Powerful Payment Integrations
- **Multiple Payment Methods**: Supports a variety of payment options including credit cards, debit cards, wallets, and alternative payment methods, giving your users more choices.
- **Pre-Built UI Components**: Offers customizable pre-built UI elements for payment forms that save development time while maintaining a delightful user experience.
- **Tokenization**: Implements secure tokenization to safely handle sensitive card data, reducing PCI compliance scope.

#### 2. Customizable User Interface
- **Custom Themes**: Easily customize UI elements to match your app's branding, ensuring a seamless user experience.
- **Adaptive Design**: Automatically adapts to different screen sizes and device orientations, providing a consistent experience across Android and iOS.

#### 3. Seamless User Experience
- **One-Tap Payments**: Supports one-tap payments for returning users, allowing for a faster checkout process.
- **Automatic Error Handling**: Built-in error messaging and form validation, ensuring that issues like incorrect card details are clearly communicated to users.
- **Localized UI**: Offers built-in localization for multiple languages, ensuring the payment experience feels native to all your users.

#### 4. Easy Integration
- **SDK Compatibility**: Compatible with Android and iOS native development environments, providing straightforward integration with existing applications.
- **Comprehensive Documentation**: Includes thorough guides and examples, making it easy for developers of all skill levels to integrate Yuno’s SDK.

#### 5. Security Features
- **PCI Compliance**: Adheres to PCI DSS standards, ensuring that your payment processing meets industry security requirements.
- **3D Secure Support**: Supports 3D Secure for additional user authentication, reducing fraud risk.
- **Data Encryption**: All transactions are protected with advanced encryption protocols, ensuring that sensitive information remains secure.

#### 6. Developer-Friendly Tools
- **Sandbox Environment**: Provides a sandbox mode for testing payment flows before going live.
- **Real-Time Logs**: Access to real-time logs helps developers quickly identify and troubleshoot issues.
- **Flexible API**: Offers a flexible and well-documented API, allowing for advanced customizations when needed.

#### 7. Real-Time Analytics
- **Insights Dashboard**: Gain insights into payment performance with a real-time analytics dashboard.
- **Error Reporting**: Get notified about transaction issues, enabling quick resolution.


## Installation
```sh
dart pub add yuno
```

## Requirements

#### Android
This plugin requires several changes to be able to work on Android devices. Please make sure you follow all these steps:

1. Yuno Android SDK needs your minSdkVersion to be 21 or above.
2. Your project must have Java 8 enabled and use AndroidX instead of older support libraries
3. The android-gradle-plugin version must be 4.0.0 or above.
4. The Proguard version must be 6.2.2 or above.
5. The kotlin-gradle-plugin version must be 1.4.0 or above
6. Using `FlutterFragmentActivity` instead of `FlutterActivity` in `MainActivity.kt`.
7. Colors or custumizations of the SDK for android you can do this by following the steps: [customs](https://docs.y.uno/docs/sdk-customizations-android)
8. Rebuild the app, as the above changes don't update with hot reload


### Android Configuration
#### build.graddle - project level 
```groovy
allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url "https://yunopayments.jfrog.io/artifactory/snapshots-libs-release" }
    }
}
```
#### MainActivity.kt

```kotlin
class MainActivity: FlutterFragmentActivity()
```

## Usage

### Examples
Here are small examples that show you how to use the API.

#### Initialize configuration
<?code-excerpt "readme_excerpts.dart (Write)"?>
```dart
await Yuno.init(
  apiKey: 'your_api_key_here',
  countryCode: 'your_country_code',
  yunoConfig: YunoConfig(
    lang: YunoLanguage.en, //supported languages: ENGLISH, SPANISH, PORTUGUESE, MALAY, INDONESIAN, THAI
    cardflow: CARDFLOW.twoStep, // default cardflow
    saveCardEnable: true, // default saveCardEnable
    keepLoader: true,   // default saveCardEnable 
    isDynamicViewEnable: true, // default isDynamicViewEnable
  ),
  iosConfig: IosConfig(), // Optional, can use default value
);
```




### Migration and Prefixes



### Testing



<?code-excerpt "readme_excerpts.dart (Tests)"?>
```dart

```
