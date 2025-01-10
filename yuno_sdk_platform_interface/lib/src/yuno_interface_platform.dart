import 'dart:async';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:yuno_sdk_core/lib.dart';
import '../yuno_sdk_platform_interface.dart';

/// {@template commons_YunoPlatform}
/// ## YunoPlatform
///
/// The `YunoPlatform` class serves as an abstraction layer to unify and streamline
/// communication with various underlying platform implementations of the Yuno SDK.
/// It provides a set of methods to initialize the SDK, handle payments (both standard and "lite"),
/// manage loaders, handle incoming deeplinks, and more.
///
/// ### Retrieving an Instance
///
/// To access the current platform implementation, you can use:
///
/// ```dart
/// final instance = YunoPlatform.instance;
/// ```
///
/// This instance will point to a platform-specific implementation, such as the default
/// method channel implementation (`YunoMethodChannel`), or a custom one provided
/// by a third-party platform class.
///
/// ### Custom Platform Implementations
///
/// Platform-specific implementations should:
/// 1. Extend `YunoPlatform`.
/// 2. Provide a token validation via `PlatformInterface.verifyToken`.
/// 3. Assign themselves to the static `instance` field for use throughout the app.
///
/// By default, `YunoPlatform` uses the `YunoMethodChannel` implementation, but you can
/// override it at runtime:
///
/// ```dart
/// final myCustomPlatform = MyCustomPlatform();
/// YunoPlatform.instance = myCustomPlatform;
/// ```
///
/// This flexibility ensures that developers can plug in their own platform-specific
/// implementations without modifying the core application code.
///
/// {@endtemplate}
abstract interface class YunoPlatform extends PlatformInterface {
  /// Constructs a [YunoPlatform] and provides a verification token to ensure
  /// platform integrity.
  ///
  /// This constructor should only be called by the platform-specific implementation.
  YunoPlatform() : super(token: _token);

  /// A unique token used for verifying the authenticity of the provided platform implementation.
  ///
  /// Internal use only. Passed to the superclass [PlatformInterface] for verification.
  static final Object _token = Object();

  /// Holds a reference to the currently active [YunoPlatform] implementation.
  ///
  /// By default, this is set to the result of:
  ///
  /// ```dart
  /// const YunoMethodChannelFactory().create()
  /// ```
  ///
  /// You can replace it with a custom platform implementation as needed.
  static YunoPlatform _instance = const YunoMethodChannelFactory().create();

  /// The default instance of [YunoPlatform] to use throughout the application.
  ///
  /// This returns the currently set platform instance. If no custom implementation
  /// is assigned, it defaults to the `YunoMethodChannel` based implementation.
  ///
  /// Example:
  /// ```dart
  /// final instance = YunoPlatform.instance;
  /// ```
  static YunoPlatform get instance => _instance;

  /// Sets the instance of [YunoPlatform] to be used.
  ///
  /// Use this setter when you have a custom platform implementation that you want
  /// the application to use, for instance:
  ///
  /// ```dart
  /// YunoPlatform.instance = MyCustomYunoPlatform();
  /// ```
  ///
  /// It verifies that the provided [instance] is legitimate by calling [PlatformInterface.verifyToken].
  static set instance(YunoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Initializes the Yuno SDK with the necessary configuration.
  ///
  /// This method must be called before invoking other payment-related methods.
  ///
  /// Parameters:
  /// - [apiKey]: Your unique API key provided by Yuno.
  /// - [countryCode]: The ISO 3166-1 alpha-2 country code where the payment is taking place.
  /// - [yunoConfig]: A [YunoConfig] object containing additional Yuno SDK configuration.
  /// - [iosConfig]: (Optional) An [IosConfig] object with iOS-specific setup parameters.
  /// - [androidConfig]: (Optional) An [AndroidConfig] object with Android-specific setup parameters.
  ///
  /// Example:
  /// ```dart
  /// await YunoPlatform.instance.initialize(
  ///   apiKey: 'YOUR_API_KEY',
  ///   countryCode: 'US',
  ///   yunoConfig: YunoConfig(),
  ///   iosConfig: IosConfig(),
  ///   androidConfig: AndroidConfig(),
  /// );
  /// ```
  Future<void> initialize({
    required String apiKey,
    required String countryCode,
    required YunoConfig yunoConfig,
    IosConfig iosConfig,
    AndroidConfig androidConfig,
  });

  /// Hides the payment loader or any loading indicator currently displayed.
  ///
  /// This can be used to manually dismiss loaders if needed, or as part of the
  /// payment flow when a loader is no longer required.
  ///
  /// Example:
  /// ```dart
  /// await YunoPlatform.instance.hideLoader();
  /// ```
  Future<void> hideLoader();

  /// Receives and processes a deeplink [url].
  ///
  /// This can be used to handle incoming links that trigger certain payment flows
  /// or navigate the user to specific parts of the payment process.
  ///
  /// Example:
  /// ```dart
  /// await YunoPlatform.instance.receiveDeeplink(
  ///   url: Uri.parse('yuno://payment-status/success')
  /// );
  /// ```
  Future<void> receiveDeeplink({
    required Uri url,
  });

  /// Starts a "Payment Lite" process with the given [arguments] and [countryCode].
  ///
  /// The "Payment Lite" flow may be a simplified or embedded payment experience
  /// depending on the platform implementation.
  ///
  /// Parameters:
  /// - [arguments]: An instance of [StartPayment] containing the parameters needed
  ///   to initiate the payment.
  /// - [countryCode]: The ISO 3166-1 alpha-2 country code for the payment.
  ///
  /// Example:
  /// ```dart
  /// await YunoPlatform.instance.startPaymentLite(
  ///   arguments: StartPayment(...),
  ///   countryCode: 'US',
  /// );
  /// ```
  Future<void> startPaymentLite({
    required StartPayment arguments,
    required String countryCode,
  });

  /// Initiates a full payment process.
  ///
  /// The [showPaymentStatus] flag indicates whether the payment status should be
  /// visually displayed to the user. Setting it to `true` ensures that the user
  /// receives feedback about the payment state.
  ///
  /// Example:
  /// ```dart
  /// await YunoPlatform.instance.startPayment(showPaymentStatus: true);
  /// ```
  Future<void> startPayment({
    bool showPaymentStatus = true,
  });

  /// Continues a previously started payment process.
  ///
  /// Similar to [startPayment], it accepts a [showPaymentStatus] parameter to control
  /// the visibility of the payment status to the user. This method is typically
  /// called after a partial payment step has been completed and the payment process
  /// needs to resume.
  ///
  /// Example:
  /// ```dart
  /// await YunoPlatform.instance.continuePayment(showPaymentStatus: false);
  /// ```
  Future<void> continuePayment({
    bool showPaymentStatus = true,
  });

  /// Performs an initialization step that may be required by specific platforms.
  ///
  /// This method may be a no-op for some implementations, or it could handle certain
  /// setup routines that must be called after the initial configuration but before
  /// payment operations.
  ///
  /// Example:
  /// ```dart
  /// await YunoPlatform.instance.init();
  /// ```
  Future<void> setup();

  /// Initiates an enrollment payment flow.
  ///
  /// The enrollment process may involve storing payment details, verifying user
  /// identity, or setting up recurring payment methods.
  ///
  /// Parameters:
  /// - [arguments]: An [EnrollmentArguments] instance containing the necessary
  ///   data to initiate the enrollment payment flow.
  ///
  /// Example:
  /// ```dart
  /// await YunoPlatform.instance.enrollmentPayment(
  ///   arguments: EnrollmentArguments(...)
  /// );
  /// ```
  Future<void> enrollmentPayment({
    required EnrollmentArguments arguments,
  });

  Future<YunoStatus> startPaymentSeamlessLite({
    required SeamlessArguments arguments,
    required YunoLanguage language,
  });

  /// A [YunoPaymentNotifier] used to listen for changes and updates to the payment process.
  ///
  /// Through the [controller], developers can subscribe to events, status changes,
  /// and other signals emitted during the payment flow.
  ///
  /// Example:
  /// ```dart
  /// final controller = YunoPlatform.instance.controller;
  /// controller.addListener(() {
  ///   // Handle payment status updates
  /// });
  /// ```
  YunoPaymentNotifier get controller;

  /// A [YunoEnrollmentNotifier] used to observe changes related to enrollment operations.
  ///
  /// This controller can be used to monitor enrollment states, updates, and results,
  /// allowing the application to react accordingly.
  ///
  /// Example:
  /// ```dart
  /// final enrollmentController = YunoPlatform.instance.enrollmentController;
  /// enrollmentController.addListener(() {
  ///   // Handle enrollment updates
  /// });
  /// ```
  YunoEnrollmentNotifier get enrollmentController;
}
