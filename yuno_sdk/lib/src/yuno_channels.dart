import 'package:yuno_sdk_platform_interface/lib.dart';

class YunoChannels {
  static YunoPlatform? __platform;
  static YunoPlatform get _platform {
    __platform ??= YunoPlatform.instance;
    return __platform!;
  }

  static Future<void> init({
    required String apiKey,
    IosConfig? iosConfig,
    AndroidConfig? androidConfig,
  }) async {

    //TODO: implemented validtion  depend is Full or Lite
    await _platform.liteInitialize(
      apiKey: apiKey,
      iosConfig: iosConfig,
      androidConfig: androidConfig,
    );

    await _platform.liteInitialize(
      apiKey: apiKey,
      iosConfig: iosConfig,
      androidConfig: androidConfig,
    );
  }
}
