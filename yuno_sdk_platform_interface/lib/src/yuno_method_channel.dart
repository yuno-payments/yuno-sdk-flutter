import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:yuno_sdk_core/lib.dart';
import 'package:yuno_sdk_platform_interface/yuno_sdk_platform_interface.dart';
import 'features/start_payment/models/parsers.dart';
import 'utils/utils.dart';

/// {@template commons_YunoMethodChannel}
/// ## YunoMethodChannel
///
/// `YunoMethodChannel` is a concrete implementation of the [YunoPlatform] interface
/// that communicates with the underlying native platform code (iOS or Android) via a
/// [MethodChannel].
///
/// ### Key Responsibilities
/// - **Initialization**: Sets up the communication channel and optionally handles
///   native-side initial configuration.
/// - **Payment Lifecycle**: Starts, continues, and manages payment flows, including
///   "Payment Lite" and enrollment processes.
/// - **Deeplink Handling**: Processes incoming URIs to route users back into the
///   payment flow.
/// - **Events and Status Updates**: Utilizes [YunoPaymentNotifier] and
///   [YunoEnrollmentNotifier] to broadcast status changes and tokens received from
///   the platform.
///
/// ### Accessing Platform Methods
/// By default, `YunoMethodChannel` is the underlying implementation returned by:
///
/// ```dart
/// YunoPlatform.instance = const YunoMethodChannelFactory().create();
/// ```
///
/// If you need to customize the platform interaction, consider overriding the
/// `YunoPlatform.instance` with a custom class that extends [YunoPlatform].
///
/// {@endtemplate}
final class YunoMethodChannel implements YunoPlatform {
  /// The method channel used to interact with the native platform.
  ///
  /// This channel communicates with the host platform (iOS/Android) code,
  /// sending messages (method calls) and receiving callbacks (method call handlers).
  final MethodChannel _methodChannel;

  /// Notifier for payment-related events and updates.
  ///
  /// The [YunoPaymentNotifier] provides a stream of events including tokens and
  /// payment statuses, allowing the application to react to changes in real-time.
  final YunoPaymentNotifier _yunoNotifier;

  /// Notifier for enrollment-related events and updates.
  ///
  /// Similar to [_yunoNotifier], this handles status updates specifically
  /// for enrollment flows.
  final YunoEnrollmentNotifier _yunoEnrollmentNotifier;

  /// Indicates if the current platform is iOS.
  final bool _platformIsIos;

  /// Indicates if the current platform is Android.
  final bool _platformIsAndroid;

  /// Constructs a new [YunoMethodChannel] instance.
  ///
  /// Parameters:
  /// - [methodChannel]: The [MethodChannel] to use for native communication.
  /// - [platformIsIos]: A boolean indicating if the platform is iOS.
  /// - [platformIsAndroid]: A boolean indicating if the platform is Android.
  /// - [yunoNotifier]: A [YunoPaymentNotifier] instance for payment event notifications.
  /// - [yunoEnrollmentNotifier]: A [YunoEnrollmentNotifier] instance for enrollment event notifications.
  YunoMethodChannel({
    required MethodChannel methodChannel,
    required bool platformIsIos,
    required bool platformIsAndroid,
    required YunoPaymentNotifier yunoNotifier,
    required YunoEnrollmentNotifier yunoEnrollmentNotifier,
  })  : _methodChannel = methodChannel,
        _yunoNotifier = yunoNotifier,
        _yunoEnrollmentNotifier = yunoEnrollmentNotifier,
        _platformIsIos = platformIsIos,
        _platformIsAndroid = platformIsAndroid;

  /// For testing purposes, exposes the internal flag that indicates if the current
  /// platform is iOS.
  @visibleForTesting
  bool get isIos => _platformIsIos;

  /// For testing purposes, exposes the internal flag that indicates if the current
  /// platform is Android.
  @visibleForTesting
  bool get isAndroid => _platformIsAndroid;

  @override
  Future<void> setup() async {
    /// Sets a method call handler to receive callbacks from the platform side.
    ///
    /// Supported callback methods:
    /// - `'ott'`: Receives a token string and notifies the payment notifier.
    /// - `'status'`: Receives an integer index mapped to a [YunoStatus] and updates the payment status.
    /// - `'enrollmentStatus'`: Receives an integer index mapped to a [YunoStatus] for enrollment flows.
    _methodChannel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case 'ott':
          if (call.arguments is! String) return;
          final token = call.arguments as String;
          _yunoNotifier.add(token);
          break;
        case 'status':
          if (call.arguments is! int) return;
          final index = call.arguments as int;
          _yunoNotifier.addStatus(YunoStatus.values[index]);
          break;
        case 'enrollmentStatus':
          if (call.arguments is! int) return;
          final index = call.arguments as int;
          _yunoEnrollmentNotifier.addEnrollmentStatus(YunoStatus.values[index]);
          break;
        default:
          throw MissingPluginException(
              'Not implemented method: ${call.method}');
      }
    });
  }

  @override
  Future<void> initialize({
    required String apiKey,
    required String countryCode,
    required YunoConfig yunoConfig,
    IosConfig? iosConfig,
    AndroidConfig? androidConfig,
  }) async {
    /// Initializes the native side of the Yuno SDK.
    ///
    /// Parameters:
    /// - [apiKey]: The Yuno API key.
    /// - [countryCode]: The ISO code of the country in which the payment occurs.
    /// - [yunoConfig]: Configuration object for the Yuno SDK.
    /// - [iosConfig] and [androidConfig]: Platform-specific configurations.
    ///
    /// This method sends a map of parameters to the native side to establish initial state.
    final mapper = Parser.toMap(
      apiKey: apiKey,
      countryCode: countryCode,
      yunoConfig: yunoConfig,
      configuration: iosConfig?.toMap(),
    );
    YunoSharedSingleton.setValue(KeysSingleton.countryCode.name, countryCode);
    await _methodChannel.invokeMethod('initialize', mapper);
  }

  @override
  Future<void> continuePayment({
    bool showPaymentStatus = true,
  }) async {
    /// Continues a previously initiated payment flow.
    ///
    /// [showPaymentStatus]: Whether to show the payment status to the user.
    await _methodChannel.invokeMethod('continuePayment', showPaymentStatus);
  }

  @override
  Future<void> startPaymentLite({
    required StartPayment arguments,
    String countryCode = '',
  }) async {
    /// Initiates a "Payment Lite" flow, which may be a streamlined payment experience.
    ///
    /// Parameters:
    /// - [arguments]: Payment parameters encapsulated in a [StartPayment] object.
    /// - [countryCode]: The country code for the payment context.
    final data = arguments.toMap(countryCode: countryCode);
    await _methodChannel.invokeMethod('startPaymentLite', data);
  }

  @override
  Future<void> hideLoader() async {
    /// Hides any loader or waiting indicator currently being displayed.
    await _methodChannel.invokeMethod('hideLoader');
  }

  @override
  Future<void> receiveDeeplink({
    required Uri url,
  }) async {
    /// Processes a deeplink URL that may resume or alter the current payment flow.
    ///
    /// Passes the string representation of the [url] to the native layer.
    await _methodChannel.invokeMethod('receiveDeeplink', url.toString());
  }

  @override
  Future<void> startPayment({
    bool showPaymentStatus = true,
  }) async {
    /// Starts a full payment process.
    ///
    /// [showPaymentStatus]: Determines if the payment status should be displayed to the user.
    await _methodChannel.invokeMethod(
      'startPayment',
      ParserStartPayment.toMap(showPaymentStatus: showPaymentStatus),
    );
  }

  @override
  Future<void> enrollmentPayment({
    required EnrollmentArguments arguments,
  }) async {
    /// Initiates an enrollment payment process.
    ///
    /// [arguments]: Configuration for enrollment steps, including user credentials or card details.
    await _methodChannel.invokeMethod(
      'enrollmentPayment',
      arguments.toMap(),
    );
  }

  @override
  Future<void> startPaymentSeamlessLite(
      {required SeamlessArguments arguments}) async {
    await _methodChannel.invokeMethod(
        'startPaymentSeamless', arguments.toMap());
  }

  @override
  YunoPaymentNotifier get controller => _yunoNotifier;

  @override
  YunoEnrollmentNotifier get enrollmentController => _yunoEnrollmentNotifier;
}

/// {@template commons_YunoMethodChannelFactory}
/// ## YunoMethodChannelFactory
///
/// `YunoMethodChannelFactory` provides a simple way to instantiate a default
/// `YunoMethodChannel` object that is compatible with the current platform.
/// It sets up the method channel and provides the necessary notifiers.
///
/// ### Example
/// ```dart
/// YunoPlatform.instance = const YunoMethodChannelFactory().create();
/// ```
/// {@endtemplate}
final class YunoMethodChannelFactory {
  /// Creates a new instance of [YunoMethodChannelFactory].
  const YunoMethodChannelFactory();

  /// Creates a [YunoMethodChannel] with default configurations.
  ///
  /// By default:
  /// - Uses `MethodChannel('yuno/payments')`.
  /// - Initializes [YunoPaymentNotifier] and [YunoEnrollmentNotifier].
  /// - Detects the current platform (iOS or Android) using [Platform].
  YunoPlatform create() => YunoMethodChannel(
        methodChannel: const MethodChannel('yuno/payments'),
        yunoNotifier: YunoPaymentNotifier(),
        yunoEnrollmentNotifier: YunoEnrollmentNotifier(),
        platformIsIos: Platform.isIOS,
        platformIsAndroid: Platform.isAndroid,
      );
}
