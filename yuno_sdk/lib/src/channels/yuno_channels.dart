import '../internals.dart';

/// The `Yuno` class provides an abstract interface for initializing and interacting with the Yuno SDK.
///
/// This class exposes the `init` method, which must be used to create an instance of `Yuno`.
/// Once initialized, you can use the instance to interact with the SDK.
///
/// Example usage:
///
/// ```dart
///
/// final yuno = await Yuno.init(
///   apiKey: 'your_api_key_here',
///   sdkType: YunoSdkType.full || YunoSdkType.lite,
///   iosConfig: IosConfig(), // Optional, can use default value
///   androidConfig: AndroidConfig(), // Optional, can use default value
/// );
/// ```
abstract interface class Yuno {
  /// Initializes the Yuno SDK.
  ///
  /// This method must be called before any other interaction with the SDK. It returns a `Yuno`
  /// instance, which can be used to interact with the SDK.
  ///
  /// The method takes the following required parameters:
  /// - `apiKey`: The API key provided by Yuno.
  /// - `sdkType`: The type of SDK should be (`YunoSdkType.full` or `YunoSdkType.lite`).
  ///
  /// The following optional parameters are available:
  /// - `iosConfig`: The configuration for iOS (default is `IosConfig()`).
  /// - `androidConfig`: The configuration for Android (default is `AndroidConfig()`).
  ///
  /// Example usage:
  /// ```dart
  /// final yuno = await Yuno.init(
  ///   apiKey: 'your_api_key_here',
  ///   sdkType: YunoSdkType.full || YunoSdkType.lite,
  /// );
  /// ```
  static Future<Yuno> init({
    required String apiKey,
    required YunoSdkType sdkType,
    IosConfig iosConfig = const IosConfig(),
    AndroidConfig androidConfig = const AndroidConfig(),
  }) async {
    final yuno = _YunoChannels(sdkType: sdkType);
    await yuno.init(
      apiKey: apiKey,
      iosConfig: iosConfig,
      androidConfig: androidConfig,
    );
    return yuno;
  }

  Future<void> openPaymentMethodsScreen();
}

final class _YunoChannels implements Yuno {
  const _YunoChannels({
    required this.sdkType,
  });
  final YunoSdkType sdkType;
  static YunoPlatform? __platform;
  static YunoPlatform get _platform {
    __platform ??= YunoPlatform.instance;
    return __platform!;
  }

  Future<void> init({
    required String apiKey,
    IosConfig? iosConfig,
    AndroidConfig? androidConfig,
  }) async {
    await _platform.initialize(
      apiKey: apiKey,
      iosConfig: iosConfig,
      androidConfig: androidConfig,
    );
  }

  @override
  Future<void> openPaymentMethodsScreen() {
    if (sdkType == YunoSdkType.lite) {
      throw YunoNotSupport();
    } else {}

    throw UnimplementedError();
  }
}
