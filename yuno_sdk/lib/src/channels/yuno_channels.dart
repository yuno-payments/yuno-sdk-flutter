import '../internals.dart';

/// The `Yuno` class provides an abstract interface for initializing and interacting with the Yuno SDK.
///
/// This class exposes the `init` method, which must be used to create an instance of `Yuno`.
/// Once initialized, you can use the instance to interact with the SDK.
///
/// Example usage:
///
/// ```dart
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
  /// ### Required Parameters:
  /// - `apiKey`: The API key provided by Yuno. This is used to authenticate and authorize API requests.
  /// - `countryCode`: The country code associated with the user's location (e.g., "US" for the United States).
  ///
  /// ### Optional Parameters:
  /// - `lang`: The language for the SDK's user interface. Defaults to `YunoLanguage.en` (English).
  /// - `cardflow`: The card flow configuration for the payment process. Defaults to `CARDFLOW.oneStep`.
  /// - `saveCardEnable`: A boolean flag indicating whether the option to save card details is enabled. Defaults to `false`.
  /// - `keepLoader`: A boolean flag indicating whether to keep the loader visible during SDK operations. Defaults to `false`.
  /// - `isDynamicViewEnable`: A boolean flag indicating whether dynamic view updates are enabled. Defaults to `false`.
  /// - `iosConfig`: The configuration for iOS, allowing customization of the SDK's behavior on iOS devices. Defaults to `IosConfig()`.
  /// - `androidConfig`: The configuration for Android, allowing customization of the SDK's behavior on Android devices. Defaults to `AndroidConfig()`.
  ///
  /// ### Example usage:
  /// ```dart
  /// final yuno = await Yuno.init(
  ///   apiKey: 'your_api_key_here',
  ///   countryCode: 'your_country_code',
  ///   lang: YunoLanguage.es,
  ///   cardflow: CARDFLOW.twoStep,
  ///   saveCardEnable: true,
  ///   keepLoader: true,
  ///   isDynamicViewEnable: true,
  ///   iosConfig: IosConfig(),
  ///   androidConfig: AndroidConfig(),
  /// );
  /// ```
  static Future<Yuno> init({
    required String apiKey,
    required String countryCode,
    YunoLanguage lang = YunoLanguage.en,
    CARDFLOW cardflow = CARDFLOW.oneStep,
    bool saveCardEnable = false,
    bool keepLoader = false,
    bool isDynamicViewEnable = false,
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
