import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'yuno_sdk_foundation_platform_interface.dart';

/// An implementation of [YunoSdkFoundationPlatform] that uses method channels.
class MethodChannelYunoSdkFoundation extends YunoSdkFoundationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('yuno_sdk_foundation');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
