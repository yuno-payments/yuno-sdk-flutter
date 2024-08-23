import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:yuno_sdk_platform_interface/lib.dart';

class YunoMethodChannel implements YunoPlatform {
  /// The method channel used to interact with the native platform.

  YunoMethodChannel({
    required MethodChannel methodChannel,
    required bool platformIsIos,
    required bool platformIsAndroid,
  })  : _methodChannel = methodChannel,
        _platformIsAndroid = platformIsAndroid,
        _platformIsIos = platformIsIos;

  @visibleForTesting
  bool get isIos => _platformIsIos;
  @visibleForTesting
  bool get isAndroid => _platformIsAndroid;

  final MethodChannel _methodChannel;
  final bool _platformIsIos;
  final bool _platformIsAndroid;

  @override
  Future<void> initialize({
    required String apiKey,
    IosConfig? iosConfig,
    AndroidConfig? androidConfig,
  }) async {
    final mapper = isAndroid
        ? Parser.toMap(
            apiKey: apiKey,
            configuration: androidConfig?.toMap(),
          )
        : Parser.toMap(
            apiKey: apiKey,
            configuration: iosConfig?.toMap(),
          );
    await _methodChannel.invokeMethod('initialize', mapper);
  }
}

/// {@template commons_YunoMethodChannelFactory}
/// ## YunoMethodChannelFactory
/// ```
///  static YunoPlatform _instance = const YunoMethodChannelFactory().create();
/// ```
/// {@endtemplate}
class YunoMethodChannelFactory {
  const YunoMethodChannelFactory();

  YunoPlatform create() => YunoMethodChannel(
        methodChannel: const MethodChannel(
          'yuno/payments',
        ),
        platformIsIos: Platform.isIOS,
        platformIsAndroid: Platform.isAndroid,
      );
}
