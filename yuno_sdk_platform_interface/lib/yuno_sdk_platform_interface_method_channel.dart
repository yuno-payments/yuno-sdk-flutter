import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'yuno_sdk_platform_interface_platform_interface.dart';

/// An implementation of [YunoSdkPlatformInterfacePlatform] that uses method channels.
class MethodChannelYunoSdkPlatformInterface extends YunoSdkPlatformInterfacePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('yuno_sdk_platform_interface');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
