import 'package:yuno_sdk_platform_interface/lib.dart';

class Yuno {

    static YunoPlatform? __platform;
      static YunoPlatform get _platform {
    __platform ??= YunoPlatform.instance;
    return __platform!;
  }

  static Future<void> liteInit() async => await _platform.liteInitialize();
  static Future<void> fullInit() async => await _platform.liteInitialize();

}
