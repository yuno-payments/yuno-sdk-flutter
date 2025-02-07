# Yuno - Flutter

<p>
<img alt="" loading="lazy" src="https://files.readme.io/2e1d03a6eec5051a64763f36225454778d7125c344f1d741d0c01cfcdafe4186-flutter-image.png" title="" class="" caption="" height="auto" width="auto">
</p>

<div style="text-align: center;">
  <a href="https://github.com/invertase/melos">
    <img alt="melos" src="https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=for-the-badge">
  </a>
  <a href="https://www.y.uno/">
    <img alt="Maintained by Yuno" src="https://img.shields.io/badge/maintained_by-Yuno-4E3DD8?style=for-the-badge">
  </a>
    <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg?style=for-the-badge" alt="License: MIT"></a>
</div>

<?code-excerpt path-base="example/lib"?>
<div style="text-align: center;">
Yuno Flutter SDK empowers you to create seamless payment experiences in your native Android and iOS apps built with Flutter. It offers powerful and customizable UI components that can be used directly to gather payment details from your users efficiently and effectively.
 <a href="https://github.com/yuno-payments/yuno-flutter-example/tree/develop" target="_blank">Full Example Integration</a>.
</div>



|             | Android | iOS   | Linux | macOS  | Web | Windows     |
|-------------|---------|-------|-------|--------|-----|-------------|
| **Support** | SDK 21+ | 14.0+ | None   | None  | None| None        |


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

#### 4. Security Features
- **PCI Compliance**: Adheres to PCI DSS standards, ensuring that your payment processing meets industry security requirements.
- **3D Secure Support**: Supports 3D Secure for additional user authentication, reducing fraud risk.
- **Data Encryption**: All transactions are protected with advanced encryption protocols, ensuring that sensitive information remains secure.

#### 5. Developer-Friendly Tools
- **Sandbox Environment**: Provides a sandbox mode for testing payment flows before going live.
- **Real-Time Logs**: Access to real-time logs helps developers quickly identify and troubleshoot issues.
- **Flexible API**: Offers a flexible and well-documented API, allowing for advanced customizations when needed.

#### 6. Real-Time Analytics
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

#### IOS
1. Use iOS version 14.0 or above

## Android Configuration
#### build.gradle - project level 
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
#### MyApp.kt
According to the documentation, Yuno must be initialized in the Application onCreate. So follow the below steps to achieve the same:
- Setup custom application class if you don't have any.
- Create a custom `android.app.Application` class named `MyApp`.
- Add an `onCreate()` override. The class should look like this:
```kotlin
import android.app.Application
class MyApp: Application() 
    override fun onCreate() {
        super.onCreate()
    }
}
```
- Open your `AndroidManifest.xml` and find the `application` tag. In it, add an `android:name` attribute, and set the value to your class' name, prefixed by a dot (.).
```xml
<application
  android:name=".MyApp" >
```
- Now initialize the Yuno SDK inside the `onCreate()` of custom application class according to the following:
```kotlin
import android.app.Application
import com.yuno_flutter.yuno_sdk_android.YunoSdkAndroidPlugin

class MyApp : Application() {
  override fun onCreate() {
    super.onCreate()

    // Add this line with your keys
    YunoSdkAndroidPlugin.initSdk(this, "YUNO_API_KEY")
  }
}
```
## Usage
### Examples
Here are small examples that show you how to use the API.

#### Initialize configuration
<?code-excerpt "readme_excerpts.dart (Write)"?>
```dart
await Yuno.init(
  apiKey: 'your_api_key_here',
  countryCode: 'your_country_code', // The complete list of country_codes is available on https://docs.y.uno/docs/country-coverage-yuno-sdk
  yunoConfig: YunoConfig(
    lang: YunoLanguage.en, //supported languages: ENGLISH, SPANISH, PORTUGUESE, MALAY, INDONESIAN, THAI
    cardflow: CardFlow.multiStep, // default cardflow
    saveCardEnable: true, // default saveCardEnable
    keepLoader: true,   // default keepLoader 
    isDynamicViewEnable: true, // default isDynamicViewEnable
  ),
  iosConfig: IosConfig(), // Optional, can use default value
);
```


## Yuno Widgets

### Listeners
**YunotListeners** are Flutter widgets that take a child widget.
And a callback function `listener` as required parameters. The widgets
itself does not perform any actions but can be extended or used as a
placeholder where a state listening mechanism is needed.
This widget can be useful in scenarios where you need to trigger certain actions or updates in the UI when a specific state changes.

### YunoPaymentListener
```dart
YunoPaymentListener(
  listener: (state) {
    // Handle [state] it is YunoState [String token] && [PaymentStatus status]
    // - [token]: One Time Token
    // - [paymentStatus]: [reject,succeeded,fail,processing,internalError,cancelByUser]
  },
  child: SomeWidget(),
)
```

### YunoEnrollmentListener
```dart
YunoEnrollmentListener(
  listener: (state) {
    // Handle [state] it is YunoEnrollmentState
    // - [enrollmentStatus]: [reject,succeeded,fail,processing,internalError,cancelByUser]
  },
  child: SomeWidget(),
)
```
### YunoMultiListener
```dart
YunoMultiListener(
  enrollmentListener: (state) {
    // Handle [state] it is YunoEnrollmentState
    // - [enrollmentStatus]: [reject,succeeded,fail,processing,internalError,cancelByUser]
  },
  paymentListener: (state) {
    // Handle [state] it is YunoPaymentState [String token] && [PaymentStatus status]
    // - [token]: One Time Token
    // - [paymentStatus]: [reject,succeeded,fail,processing,internalError,cancelByUser]
  }
  child: SomeWidget(),
)
```
### YunoPaymentMethods
**YunoPaymentMethods** 
is a Flutter widget that displays payment methods using a native iOS and Android views.
This widget integrates with the Yuno SDK to show payment methods in a Flutter app.
It dynamically adjusts its size based on the content and available width.
The widget provides a listener to notify about selection changes, allowing
the parent widget to react to user interactions with the payment methods.

***The following widget works only with Yuno's full SDK version.***
```dart
YunoPaymentMethods(
  config: PaymentMethodConf(
    checkoutSession: 'your_checkout_session_id',
    // Add other configuration options as needed
  ),
  listener: (context, isSelected) {
    if (isSelected) {
      print('A payment method has been selected');
    } else {
      print('No payment method is currently selected');
    }
  },
)
```

## Yuno Dart API
The library offers several methods to handle Yuno related actions:

```dart
Future<void> startPayment(...);
Future<void> startPaymentLite(...);
Future<void> enrollmentPayment(...)
Future<void> continuePayment(...);
Future<YunoStatus> startPaymentSeamlessLite(...)
//Avialable only for IOS devices
Future<void> receiveDeeplink(...);
Future<void> hideLoader(...);
```

## Sugar Syntax
```dart
class Sample extends StatelessWidget {
  const Sample({super.key});

  @override
  Widget build(BuildContext context) {
    context.startPaymentLite(...)
    context.startPayment(...)
    context.enrollmentPayment(...)
    context.continuePayment(...)
    //Avialable only for IOS devices
    context.receiveDeeplink(...)
    context.hideLoader(...)
  }
}
```
## Or Use
```dart
Yuno.startPaymentLite(...)
Yuno.startPayment(...)
Yuno.enrollmentPayment(...)
Yuno.continuePayment(...)
Yuno.startPaymentSeamlessLite(...)
//Avialable only for IOS devices
Yuno.receiveDeeplink(...)
Yuno.hideLoader(...)
```

## Using Yuno key with `--dart-define`

Use `--dart-define` variables to avoid hardcoding Yuno keys. 

### Pass the Yuno key with `flutter run` or `flutter build` command using `--dart-define`.
```dart
flutter run --dart-define="YUNO_API_KEY=apiKey"
```
Note: You can also use `--dart-define-from-file` which is introduced in Flutter 3.7.

### Reading keys in Dart side and initialize the SDK.
```dart
String yunoApi = String.fromEnvironment("YUNO_API", "");
```

### Reading keys in Android native side and initialize the SDK.

* Add the following code to `build.gradle` **- app level**.
* You can also see the build config in the [example Integration](https://github.com/yuno-payments/yuno-flutter-example/blob/develop/android/app/build.gradle).
```
def dartEnvironmentVariables = []
if (project.hasProperty('dart-defines')) {
  dartEnvironmentVariables = project.property('dart-defines')
      .split(',')
      .collectEntries { entry ->
        def pair = new String(entry.decodeBase64(), 'UTF-8').split('=')
        [(pair.first()): pair.last()]
      }
}
```

* Place `dartEnvironmentVariables` inside the build config
```
defaultConfig {
    ...
   
  buildConfigField 'String', 'YUNO_API_KEY', "\"${dartEnvironmentVariables.yunoApiKey}\""
}
```
#### build.gradle - app level 

* Make sure that add the following code inside the build config
```groovy
android {
    buildFeatures {
        buildConfig true
    }
 }
```

* Read the build config fields
* You can also see the MyApp.kt in the [example Integration](https://github.com/yuno-payments/yuno-flutter-example/blob/develop/android/app/src/main/kotlin/com/example/example/MyApp.kt).

```kotlin
import android.app.Application
import android.os.Build
import com.yuno_flutter.yuno_sdk_android.YunoSdkAndroidPlugin

class MyApp : Application() {
  override fun onCreate() {
    super.onCreate()
    
    // Add this line with your keys
   YunoSdkAndroidPlugin.initSdk(this, BuildConfig.YUNO_API_KEY)
  }
}
```

## Contributing

You can help us make this project better, feel free to open an new issue or a pull request.

##### Setup

This project uses [melos](https://github.com/invertase/melos) to manage all the packages inside this repo.

- Install melos: `dart pub global activate melos`
- Setup melos in your local folder: `melos bootstrap`

##### Useful commands

- Format `melos run format`
- Analyze `melos run analyze`
- Test `melos run test`
- Coverage `melos run coverage`
- Pub get `melos run get`

##### Publishing

- Use `melos version` and `melos publish` to keep all the repositories in sync!