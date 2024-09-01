import 'dart:async';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:yuno_sdk_core/commons/src/enums/yuno_language.dart';
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
    required CardFlow cardflow,
    required bool saveCardEnable,
    required bool keepLoader,
    required bool isDynamicViewEnable,
    YunoLanguage lang = YunoLanguage.en,
    IosConfig iosConfig,
    AndroidConfig androidConfig,
  });

  Future<void> hideLoader();

  Future<void> startPaymentLite({
    required StartPayment arguments,
  });

  Future<void> continuePayment({
    bool showPaymentStatus = true,
  });

  Future<void> init();
  YunoNotifier get controller;
}
