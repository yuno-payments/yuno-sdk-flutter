import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'yuno_sdk_platform_interface_method_channel.dart';

abstract class YunoSdkPlatformInterfacePlatform extends PlatformInterface {
  /// Constructs a YunoSdkPlatformInterfacePlatform.
  YunoSdkPlatformInterfacePlatform() : super(token: _token);

  static final Object _token = Object();

  static YunoSdkPlatformInterfacePlatform _instance = MethodChannelYunoSdkPlatformInterface();

  /// The default instance of [YunoSdkPlatformInterfacePlatform] to use.
  ///
  /// Defaults to [MethodChannelYunoSdkPlatformInterface].
  static YunoSdkPlatformInterfacePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [YunoSdkPlatformInterfacePlatform] when
  /// they register themselves.
  static set instance(YunoSdkPlatformInterfacePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
