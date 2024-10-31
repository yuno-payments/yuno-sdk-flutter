import 'dart:async';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import '../lib.dart';

/// {@template commons_YunoPlatform}
/// ## YunoPlatform
/// You can access to the instance using direct the static method
/// ```
/// final instance = YunoPlatform.instance;
/// ```
/// {@endtemplate}
abstract interface class YunoPlatform extends PlatformInterface {
  /// Constructs a YunoSdkPlatformInterfacePlatform.
  YunoPlatform() : super(token: _token);

  static final Object _token = Object();

  static YunoPlatform _instance = const YunoMethodChannelFactory().create();

  /// The default instance of [YunoPlatform] to use.
  ///
  /// Defaults to [YunoMethodChannel].
  static YunoPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [YunoPlatform] when
  /// they register themselves.
  static set instance(YunoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> initialize({
    required String apiKey,
    required String countryCode,
    required YunoConfig yunoConfig,
    IosConfig iosConfig,
    AndroidConfig androidConfig,
  });

  Future<void> hideLoader();

  Future<void> receiveDeeplink({
    required Uri url,
  });

  Future<void> startPaymentLite({
    required StartPayment arguments,
    required String countryCode,
  });

  Future<void> startPayment({
    bool showPaymentStatus = true,
  });

  Future<void> continuePayment({
    bool showPaymentStatus = true,
  });

  Future<void> init();

  Future<void> enrollmentPayment({
    required EnrollmentArguments arguments,
  });

  YunoPaymentNotifier get controller;
  YunoEnrollmentNotifier get enrollmentController;
}
