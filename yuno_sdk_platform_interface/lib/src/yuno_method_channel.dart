import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:yuno_sdk_core/lib.dart';
import 'package:yuno_sdk_platform_interface/yuno_sdk_platform_interface.dart';
import 'features/start_payment/models/parsers.dart';
import 'utils/utils.dart';

final class YunoMethodChannel implements YunoPlatform {
  /// The method channel used to interact with the native platform.

  YunoMethodChannel({
    required MethodChannel methodChannel,
    required bool platformIsIos,
    required bool platformIsAndroid,
    required YunoPaymentNotifier yunoNotifier,
    required YunoEnrollmentNotifier yunoEnrollmentNotifier,
  })  : _methodChannel = methodChannel,
        _yunoNotifier = yunoNotifier,
        _yunoEnrollmentNotifier = yunoEnrollmentNotifier,
        _platformIsAndroid = platformIsAndroid,
        _platformIsIos = platformIsIos;

  @visibleForTesting
  bool get isIos => _platformIsIos;
  @visibleForTesting
  bool get isAndroid => _platformIsAndroid;

  final YunoPaymentNotifier _yunoNotifier;
  final YunoEnrollmentNotifier _yunoEnrollmentNotifier;
  final MethodChannel _methodChannel;
  final bool _platformIsIos;
  final bool _platformIsAndroid;

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
    await _methodChannel.invokeMethod('continuePayment', showPaymentStatus);
  }

  @override
  Future<void> startPaymentLite({
    required StartPayment arguments,
    String countryCode = '',
  }) async {
    final data = arguments.toMap(countryCode: countryCode);
    await _methodChannel.invokeMethod('startPaymentLite', data);
  }

  @override
  Future<void> hideLoader() async {
    await _methodChannel.invokeMethod('hideLoader');
  }

  @override
  Future<void> receiveDeeplink({
    required Uri url,
  }) async {
    await _methodChannel.invokeMethod(
      'receiveDeeplink',
      url.toString(),
    );
  }

  @override
  Future<void> startPayment({
    bool showPaymentStatus = true,
  }) async =>
      await _methodChannel.invokeMethod(
        'startPayment',
        ParserStartPayment.toMap(
          showPaymentStatus: showPaymentStatus,
        ),
      );

  @override
  Future<void> enrollmentPayment({
    required EnrollmentArguments arguments,
  }) async =>
      await _methodChannel.invokeMethod(
        'enrollmentPayment',
        arguments.toMap(),
      );

  @override
  YunoPaymentNotifier get controller => _yunoNotifier;

  @override
  YunoEnrollmentNotifier get enrollmentController => _yunoEnrollmentNotifier;
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
        yunoNotifier: YunoPaymentNotifier(),
        yunoEnrollmentNotifier: YunoEnrollmentNotifier(),
        platformIsIos: Platform.isIOS,
        platformIsAndroid: Platform.isAndroid,
      );
}
