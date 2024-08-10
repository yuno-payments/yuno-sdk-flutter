import 'internals.dart';

class YunoChannels {
  static YunoPlatform? __platform;
  static YunoPlatform get _platform {
    __platform ??= YunoPlatform.instance;
    return __platform!;
  }

  static Future<void> init({
    required String apiKey,
    required YunoSdkType sdkType,
    IosConfig? iosConfig,
    AndroidConfig? androidConfig,
  }) async {

    if (sdkType == YunoSdkType.full) {
      await _platform.fullInitialize(
        apiKey: apiKey,
        iosConfig: iosConfig,
        androidConfig: androidConfig,
      );
    }else{
      await _platform.liteInitialize(
      apiKey: apiKey,
      iosConfig: iosConfig,
      androidConfig: androidConfig,
    );
    }
  
  }
}
