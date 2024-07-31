import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'yuno_sdk_android_method_channel.dart';

abstract class YunoSdkAndroidPlatform extends PlatformInterface {
  /// Constructs a YunoSdkAndroidPlatform.
  YunoSdkAndroidPlatform() : super(token: _token);

  static final Object _token = Object();

  static YunoSdkAndroidPlatform _instance = MethodChannelYunoSdkAndroid();

  /// The default instance of [YunoSdkAndroidPlatform] to use.
  ///
  /// Defaults to [MethodChannelYunoSdkAndroid].
  static YunoSdkAndroidPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [YunoSdkAndroidPlatform] when
  /// they register themselves.
  static set instance(YunoSdkAndroidPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
