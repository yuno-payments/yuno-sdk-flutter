import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';



/// An implementation of [YunoSdkAndroidPlatform] that uses method channels.
class MethodChannelYunoSdkAndroid {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('yuno_sdk_android');


  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
