import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'yuno_sdk_android_platform_interface.dart';

/// An implementation of [YunoSdkAndroidPlatform] that uses method channels.
class MethodChannelYunoSdkAndroid extends YunoSdkAndroidPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('yuno_sdk_android');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
