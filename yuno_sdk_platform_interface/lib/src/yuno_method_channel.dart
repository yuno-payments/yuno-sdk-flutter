import 'dart:io';
import 'package:flutter/services.dart';
import 'package:yuno_sdk_platform_interface/src/yuno_interface_platform.dart';

class YunoMethodChannel implements YunoPlatform {
  /// The method channel used to interact with the native platform.

  YunoMethodChannel({
    required MethodChannel methodChannel,
    required bool platformIsIos,
    required bool platformIsAndroid,
  })  : _methodChannel = methodChannel,
        _platformIsAndroid = platformIsAndroid,
        _platformIsIos = platformIsIos;

  final MethodChannel _methodChannel;
  final bool _platformIsIos;
  final bool _platformIsAndroid;
  
  @override
  Future<void> liteInitialize() {
    // TODO: implement liteInitialize
    throw UnimplementedError();
  }
  
  @override
  Future<void> fullInitialize() {
    // TODO: implement fullInitialize
    throw UnimplementedError();
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