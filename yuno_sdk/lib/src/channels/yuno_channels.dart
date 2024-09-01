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
    CARDFLOW cardflow = CARDFLOW.oneStep,
    bool saveCardEnable = false,
    bool keepLoader = false,
    bool isDynamicViewEnable = false,
    YunoLanguage lang = YunoLanguage.en,
    IosConfig iosConfig = const IosConfig(),
    AndroidConfig androidConfig = const AndroidConfig(),
  }) async {
    const yuno = _YunoChannels();
    await yuno.initInvoke();
    await yuno.init(
      apiKey: apiKey,
      countryCode: countryCode,
      saveCardEnable: saveCardEnable,
      keepLoader: keepLoader,
      cardflow: cardflow,
      isDynamicViewEnable: isDynamicViewEnable,
      lang: lang,
      iosConfig: iosConfig,
      androidConfig: androidConfig,
    );

    return yuno;
  }

  Future<void> openPaymentMethodsScreen();
  Future<void> startPaymentLite({
    required StartPayment arguments,
  });
  Future<void> continuePayment({
    bool showPaymentStatus = true,
  });
  Future<void> hideLoader();
}

final class _YunoChannels implements Yuno {
  const _YunoChannels();

  static YunoPlatform? __platform;
  static YunoPlatform get _platform {
    __platform ??= YunoPlatform.instance;
    return __platform!;
  }

  Future<void> init({
    required String apiKey,
    required String countryCode,
    required CARDFLOW cardflow,
    required bool saveCardEnable,
    required bool keepLoader,
    required bool isDynamicViewEnable,
    required YunoLanguage lang,
    required IosConfig iosConfig,
    required AndroidConfig androidConfig,
  }) async =>
      await _platform.initialize(
        lang: lang,
        apiKey: apiKey,
        countryCode: countryCode,
        iosConfig: iosConfig,
        androidConfig: androidConfig,
        cardflow: cardflow,
        saveCardEnable: saveCardEnable,
        keepLoader: keepLoader,
        isDynamicViewEnable: isDynamicViewEnable,
      );
  Future<void> initInvoke() async => await _platform.init();

  @override
  Future<void> startPaymentLite({
    required StartPayment arguments,
  }) async =>
      await _platform.startPaymentLite(arguments: arguments);

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
