import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:yuno_sdk_core/lib.dart';
import 'package:yuno_sdk_platform_interface/lib.dart';

final class YunoMethodChannel implements YunoPlatform {
  /// The method channel used to interact with the native platform.

  YunoMethodChannel({
    required MethodChannel methodChannel,
    required bool platformIsIos,
    required bool platformIsAndroid,
    required YunoNotifier yunoNotifier,
  })  : _methodChannel = methodChannel,
        _yunoNotifier = yunoNotifier,
        _platformIsAndroid = platformIsAndroid,
        _platformIsIos = platformIsIos;

  @visibleForTesting
  bool get isIos => _platformIsIos;
  @visibleForTesting
  bool get isAndroid => _platformIsAndroid;

  final YunoNotifier _yunoNotifier;
  final MethodChannel _methodChannel;
  final bool _platformIsIos;
  final bool _platformIsAndroid;

  @override
  Future<void> initialize({
    required String apiKey,
    required String countryCode,
    required CARDFLOW cardflow,
    required bool saveCardEnable,
    required bool keepLoader,
    required bool isDynamicViewEnable,
    YunoLanguage lang = YunoLanguage.en,
    IosConfig? iosConfig,
    AndroidConfig? androidConfig,
  }) async {
    final mapper = isAndroid
        ? Parser.toMap(
            apiKey: apiKey,
            lang: lang,
            cardflow: cardflow,
            saveCardEnable: saveCardEnable,
            keepLoader: keepLoader,
            isDynamicViewEnable: isDynamicViewEnable,
            countryCode: countryCode,
            configuration: androidConfig?.toMap(),
          )
        : Parser.toMap(
            apiKey: apiKey,
            lang: lang,
            cardflow: cardflow,
            saveCardEnable: saveCardEnable,
            keepLoader: keepLoader,
            isDynamicViewEnable: isDynamicViewEnable,
            countryCode: countryCode,
            configuration: iosConfig?.toMap(),
          );
    await _methodChannel.invokeMethod('initialize', mapper);
  }

  @override
  Future<void> continuePayment({
    bool showPaymentStatus = true,
  }) async {
    await _methodChannel.invokeMethod('continuePayment', showPaymentStatus);
  }

  @override
  Future<void> init() async {
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
          _yunoNotifier.addStatus(PaymentStatus.values[index]);
          break;
        default:
          throw MissingPluginException(
              'Not implemented method: ${call.method}');
      }
    });
  }

  @override
  Future<void> startPaymentLite({
    required StartPayment arguments,
  }) async {
    final data = arguments.toMap();
    await _methodChannel.invokeMethod('startPaymentLite', data);
  }

  @override
  YunoNotifier get controller => _yunoNotifier;

  @override
  Future<void> hideLoader() async {
    await _methodChannel.invokeMethod('hideLoader');
  }
}

/// {@template commons_YunoMethodChannelFactory}
/// ## YunoMethodChannelFactory
/// ```
///  static YunoPlatform _instance = const YunoMethodChannelFactory().create();
/// ```
/// {@endtemplate}
final class YunoMethodChannelFactory {
  const YunoMethodChannelFactory();

  YunoPlatform create() => YunoMethodChannel(
        methodChannel: const MethodChannel(
          'yuno/payments',
        ),
        yunoNotifier: YunoNotifier(),
        platformIsIos: Platform.isIOS,
        platformIsAndroid: Platform.isAndroid,
      );
}
