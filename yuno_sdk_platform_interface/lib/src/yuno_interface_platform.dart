import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:yuno_sdk_platform_interface/src/models/android_config.dart';
import 'package:yuno_sdk_platform_interface/src/models/ios_config.dart';
import 'package:yuno_sdk_platform_interface/src/yuno_method_channel.dart';

/// {@template commons_YunoPlatform}
/// ## YunoPlatform
/// You can access to the instance using direct the static method
/// ```
/// final instance = YunoPlatform.instance;
/// ```
/// {@endtemplate}
abstract interface class YunoPlatform extends PlatformInterface {
  /// Constructs a YunoSdkPlatformInterfacePlatform.
  YunoPlatform() : super(token: _token);

  static final Object _token = Object();

  static YunoPlatform _instance = const YunoMethodChannelFactory().create();

  /// The default instance of [YunoPlatform] to use.
  ///
  /// Defaults to [YunoMethodChannel].
  static YunoPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [YunoPlatform] when
  /// they register themselves.
  static set instance(YunoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> initialize({
    required String apiKey,
    IosConfig iosConfig,
    AndroidConfig androidConfig,
  });
}
