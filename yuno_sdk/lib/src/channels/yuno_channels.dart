import '../internals.dart';

abstract interface class YunoChannels {
  Future<void> configuration({
    required String apiKey,
    required String countryCode,
    IosConfig? iosConfig,
    AndroidConfig? androidConfig,
  });

  YunoSdkType get type;
}

class YunoChannelMethods implements YunoChannels {
  const YunoChannelMethods({
    required this.sdkType,
  });
  final YunoSdkType sdkType;
  static YunoPlatform? __platform;
  static YunoPlatform get _platform {
    __platform ??= YunoPlatform.instance;
    return __platform!;
  }

  @override
  Future<void> configuration({
    required String apiKey,
    required String countryCode,
    IosConfig? iosConfig,
    AndroidConfig? androidConfig,
  }) async =>
      await _platform.initialize(
        apiKey: apiKey,
        countryCode: countryCode,
        iosConfig: iosConfig,
        androidConfig: androidConfig,
      );

  @override
  YunoSdkType get type => sdkType;
}
