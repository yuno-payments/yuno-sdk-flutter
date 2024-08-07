import 'package:yuno_sdk_platform_interface/lib.dart';

class YunoChannels {

    static YunoPlatform? __platform;
      static YunoPlatform get _platform {
    __platform ??= YunoPlatform.instance;
    return __platform!;
  }

  static Future<void> inizialise() async => await _platform.initialize();

}