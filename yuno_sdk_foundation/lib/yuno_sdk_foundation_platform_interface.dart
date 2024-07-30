import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'yuno_sdk_foundation_method_channel.dart';

abstract class YunoSdkFoundationPlatform extends PlatformInterface {
  /// Constructs a YunoSdkFoundationPlatform.
  YunoSdkFoundationPlatform() : super(token: _token);

  static final Object _token = Object();

  static YunoSdkFoundationPlatform _instance = MethodChannelYunoSdkFoundation();

  /// The default instance of [YunoSdkFoundationPlatform] to use.
  ///
  /// Defaults to [MethodChannelYunoSdkFoundation].
  static YunoSdkFoundationPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [YunoSdkFoundationPlatform] when
  /// they register themselves.
  static set instance(YunoSdkFoundationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
