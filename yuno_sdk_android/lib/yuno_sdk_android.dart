
import 'yuno_sdk_android_platform_interface.dart';

class YunoSdkAndroid {
  Future<String?> getPlatformVersion() {
    return YunoSdkAndroidPlatform.instance.getPlatformVersion();
  }
}
