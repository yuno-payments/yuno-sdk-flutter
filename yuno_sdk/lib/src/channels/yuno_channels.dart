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
///  await Yuno.init(
///   apiKey: 'your_api_key_here',
///   countryCode: 'your_country_code',
///   yunoConfig: YunoConfig(
///     lang: YunoLanguage.en,
///     cardflow: CardFlow.multiStep,
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
  /// - `iosConfig`: The configuration for iOS, allowing customization of the SDK's behavior on iOS devices. Defaults to `IosConfig()`.
  /// - `androidConfig`: The configuration for Android, allowing customization of the SDK's behavior on Android devices. Defaults to `AndroidConfig()`.
  ///
  /// ### Example usage:
  /// ```dart
  ///  await Yuno.init(
  ///   apiKey: 'your_api_key_here',
  ///   countryCode: 'your_country_code',
  ///   yunoConfig: YunoConfig(
  ///     lang: YunoLanguage.en,
  ///     cardflow: CardFlow.multiStep,
  ///     saveCardEnable: true,
  ///     keepLoader: true,
  ///   ),
  ///   iosConfig: IosConfig(),
  /// );
  /// ```
  static Future<void> init({
    required String apiKey,
    required String countryCode,
    YunoConfig yunoConfig = const YunoConfig(),
    IosConfig iosConfig = const IosConfig(),
  }) async {
    _YunoChannels.setCountryCode(countryCode);
    const yuno = _YunoChannels();
    await yuno.initInvoke();
    await yuno.init(
      apiKey: apiKey,
      countryCode: countryCode,
      yunoConfig: yunoConfig,
      iosConfig: iosConfig,
      androidConfig: const AndroidConfig(),
    );
  }

  /// Initiates the enrollment payment process.
  ///
  /// The `arguments` parameter contains the required details for initiating enrollment.
  ///
  /// ### Parameters:
  /// - `arguments`: An instance of `EnrollmentArguments` containing the enrollment details.
  ///
  /// ### Example usage:
  /// ```dart
  /// await Yuno.enrollmentPayment(
  ///   arguments: EnrollmentArguments(customerSession: 'session', showPaymentStatus: true),
  /// );
  /// ```
  static Future<void> enrollmentPayment({
    required EnrollmentArguments arguments,
  }) async =>
      await _YunoChannels.enrollmentPayment(arguments: arguments);

  /// Starts a payment process in a "lite" mode.
  ///
  /// This function allows initiating a lightweight version of the payment process.
  ///
  /// ### Parameters:
  /// - `arguments`: Details of the payment session to initiate.
  /// - `countryCode`: Optional. If omitted, defaults to the previously set country code.
  ///
  /// ### Example usage:
  /// ```dart
  /// await Yuno.startPaymentLite(
  ///   arguments: StartPayment(...),
  ///   countryCode: 'US',
  /// );
  /// ```
  static Future<void> startPaymentLite({
    required StartPayment arguments,
    String countryCode = '',
  }) async =>
      await _YunoChannels.startPaymentLite(
        arguments: arguments,
        countryCode: countryCode,
      );

  /// Starts a payment process with an option to display the payment status.
  ///
  /// This function begins a standard payment process, allowing the user to complete the transaction.
  ///
  /// ### Parameters:
  /// - `showPaymentStatus`: A boolean indicating whether the payment status should be shown to the user.
  ///
  /// ### Example usage:
  /// ```dart
  /// await Yuno.startPayment(showPaymentStatus: true);
  /// ```
  static Future<void> startPayment({
    bool showPaymentStatus = true,
  }) async =>
      await _YunoChannels.startPayment(
        showPaymentStatus: showPaymentStatus,
      );

  /// Continues a paused or pending payment process.
  ///
  /// This method resumes a previously initiated payment, allowing the user to complete it.
  ///
  /// ### Parameters:
  /// - `showPaymentStatus`: A boolean indicating whether the payment status should be shown to the user.
  ///
  /// ### Example usage:
  /// ```dart
  /// await Yuno.continuePayment(showPaymentStatus: false);
  /// ```
  static Future<void> continuePayment({
    bool showPaymentStatus = true,
  }) async =>
      _YunoChannels.continuePayment(
        showPaymentStatus: showPaymentStatus,
      );

  /// Hides the loading indicator.
  ///
  /// This function can be used to manually hide any loading indicator shown by the SDK.
  ///
  /// ### Example usage:
  /// ```dart
  /// await Yuno.hideLoader();
  /// ```
  static Future<void> hideLoader() async => _YunoChannels.hideLoader();

  /// Processes a received deep link URL.
  ///
  /// This function allows the SDK to handle a deep link URL, which might be used to resume a
  /// session or navigate to a specific part of the application.
  ///
  /// ### Parameters:
  /// - `url`: A URI representing the deep link.
  ///
  /// ### Example usage:
  /// ```dart
  /// await Yuno.receiveDeeplink(url: Uri.parse('https://example.com/deeplink'));
  /// ```
  static Future<void> receiveDeeplink({
    required Uri url,
  }) async =>
      _YunoChannels.receiveDeeplink(
        url: url,
      );
}

final class _YunoChannels implements Yuno {
  const _YunoChannels();

  static String? _countryCode;

  static void setCountryCode(String code) {
    _countryCode = code;
  }

  static String _getCountryCode() {
    if (_countryCode == null) {
      throw StateError(
          'Country code has not been initialized. Call Yuno.init() first.');
    }
    return _countryCode!;
  }

  static YunoPlatform? __platform;
  static YunoPlatform get _platform {
    __platform ??= YunoPlatform.instance;
    return __platform!;
  }

  static Future<void> enrollmentPayment({
    required EnrollmentArguments arguments,
  }) async =>
      await _platform.enrollmentPayment(
        arguments: EnrollmentArguments(
          customerSession: arguments.customerSession,
          showPaymentStatus: arguments.showPaymentStatus,
          countryCode: arguments.countryCode ?? _getCountryCode(),
        ),
      );

  Future<void> init({
    required String apiKey,
    required String countryCode,
    required YunoConfig yunoConfig,
    required IosConfig iosConfig,
    required AndroidConfig androidConfig,
  }) async =>
      await _platform.initialize(
        apiKey: apiKey,
        countryCode: countryCode,
        yunoConfig: yunoConfig,
        iosConfig: iosConfig,
        androidConfig: androidConfig,
      );

  static Future<void> receiveDeeplink({
    required Uri url,
  }) async =>
      await _platform.receiveDeeplink(url: url);

  Future<void> initInvoke() async => await _platform.init();

  static Future<void> startPaymentLite({
    required StartPayment arguments,
    String countryCode = '',
  }) async =>
      await _platform.startPaymentLite(
        arguments: arguments,
        countryCode: countryCode.isEmpty ? _getCountryCode() : countryCode,
      );

  static Future<void> startPayment({
    bool showPaymentStatus = true,
  }) async =>
      await _platform.startPayment(
        showPaymentStatus: showPaymentStatus,
      );

  static Future<void> continuePayment({
    bool showPaymentStatus = true,
  }) async =>
      await _platform.continuePayment(
        showPaymentStatus: showPaymentStatus,
      );

  static Future<void> hideLoader() async => await _platform.hideLoader();
}
