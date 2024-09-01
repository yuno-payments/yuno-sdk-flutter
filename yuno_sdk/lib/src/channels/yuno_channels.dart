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
///   countryCode: 'your_country_code',
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
  ///   countryCode: 'your_country_code',
  /// );
  /// ```
  static Future<Yuno> init({
    required String apiKey,
    required String countryCode,
    YunoConfig yunoConfig = const YunoConfig(),
    IosConfig iosConfig = const IosConfig(),
    AndroidConfig androidConfig = const AndroidConfig(),
  }) async {
    final yuno = _YunoChannels(
      countryCodeIncome: countryCode,
    );
    await yuno.initInvoke();
    await yuno.init(
      apiKey: apiKey,
      yunoConfig: yunoConfig,
      iosConfig: iosConfig,
      androidConfig: androidConfig,
    );

    return yuno;
  }

  Future<void> openPaymentMethodsScreen();
  Future<void> startPaymentLite({
    required StartPayment arguments,
    String countryCode = '',
  });
  Future<void> continuePayment({
    bool showPaymentStatus = true,
  });
  Future<void> hideLoader();
}

final class _YunoChannels implements Yuno {
  const _YunoChannels({
    required this.countryCodeIncome,
  });

  static YunoPlatform? __platform;
  static YunoPlatform get _platform {
    __platform ??= YunoPlatform.instance;
    return __platform!;
  }

  final String countryCodeIncome;
  Future<void> init({
    required String apiKey,
    required YunoConfig yunoConfig,
    required IosConfig iosConfig,
    required AndroidConfig androidConfig,
  }) async =>
      await _platform.initialize(
        apiKey: apiKey,
        yunoConfig: yunoConfig,
        iosConfig: iosConfig,
        androidConfig: androidConfig,
      );
  Future<void> initInvoke() async => await _platform.init();

  @override
  Future<void> startPaymentLite({
    required StartPayment arguments,
    String countryCode = '',
  }) async =>
      await _platform.startPaymentLite(
        arguments: arguments,
        countryCode: countryCode.isEmpty ? countryCodeIncome : countryCode,
      );

  @override
  Future<void> continuePayment({bool showPaymentStatus = true}) async =>
      await _platform.continuePayment(showPaymentStatus: showPaymentStatus);

  @override
  Future<void> hideLoader() async => await _platform.hideLoader();

  @override
  Future<void> openPaymentMethodsScreen() {
    throw UnimplementedError();
  }
}
