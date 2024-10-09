import '../internals.dart';

/// {@template yuno_channels.Yuno}
/// The `Yuno` class provides an abstract interface for initializing and interacting with the Yuno SDK.
///
/// This class exposes the `init` method, which must be used to create an instance of `Yuno`.
/// Once initialized, you can use the instance to interact with the SDK.
///
/// Example usage:
///{@tool snippet}
/// ```dart
/// final yuno = await Yuno.init(
///   apiKey: 'your_api_key_here',
///   countryCode: 'your_country_code',
///   yunoConfig: YunoConfig(
///     lang: YunoLanguage.en,
///     cardflow: CARDFLOW.twoStep,
///     saveCardEnable: true,
///     keepLoader: true,
///     isDynamicViewEnable: true,
///   ),
///   iosConfig: IosConfig(), // Optional, can use default value
/// );
/// ```
/// {@end-tool}
/// {@endtemplate}
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
  /// - `CardFlow`: The card flow configuration for the payment process. Defaults to `CARDFLOW.oneStep`.
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
  ///   yunoConfig: YunoConfig(
  ///     lang: YunoLanguage.en,
  ///     cardflow: CardFlow.twoStep,
  ///     saveCardEnable: true,
  ///     keepLoader: true,
  ///     isDynamicViewEnable: true,
  ///   ),
  ///   iosConfig: IosConfig(),
  /// );
  /// ```
  static Future<Yuno> init({
    required String apiKey,
    required String countryCode,
    YunoConfig yunoConfig = const YunoConfig(),
    IosConfig iosConfig = const IosConfig(),
  }) async {
    final yuno = _YunoChannels(
      countryCodeIncome: countryCode,
    );
    await yuno.initInvoke();
    await yuno.init(
      apiKey: apiKey,
      yunoConfig: yunoConfig,
      iosConfig: iosConfig,
      androidConfig: const AndroidConfig(),
    );

    return yuno;
  }

  Future<void> startPaymentLite({
    required StartPayment arguments,
    String countryCode = '',
  });

  Future<void> startPayment({
    bool showPaymentStatus = true,
  });

  Future<void> continuePayment({
    bool showPaymentStatus = true,
  });

  Future<void> hideLoader();

  Future<void> receiveDeeplink({required Uri url});
}

final class _YunoChannels implements Yuno {
  const _YunoChannels({
    required this.countryCodeIncome,
  });
  final String countryCodeIncome;
  static YunoPlatform? __platform;
  static YunoPlatform get _platform {
    __platform ??= YunoPlatform.instance;
    return __platform!;
  }

  Future<void> init({
    required String apiKey,
    required YunoConfig yunoConfig,
    required IosConfig iosConfig,
    required AndroidConfig androidConfig,
  }) async =>
      await _platform.initialize(
        apiKey: apiKey,
        countryCode: countryCodeIncome,
        yunoConfig: yunoConfig,
        iosConfig: iosConfig,
        androidConfig: androidConfig,
      );

  @override
  Future<void> receiveDeeplink({
    required Uri url,
  }) async =>
      await _platform.receiveDeeplink(url: url);

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
  Future<void> continuePayment({
    bool showPaymentStatus = true,
  }) async =>
      await _platform.continuePayment(
        showPaymentStatus: showPaymentStatus,
      );

  @override
  Future<void> hideLoader() async => await _platform.hideLoader();

  @override
  Future<void> startPayment({
    bool showPaymentStatus = true,
  }) =>
      _platform.startPayment(
        showPaymentStatus: showPaymentStatus,
      );
}
