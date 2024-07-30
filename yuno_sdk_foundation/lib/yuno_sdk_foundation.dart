
import 'yuno_sdk_foundation_platform_interface.dart';

class YunoSdkFoundation {
  Future<String?> getPlatformVersion() {
    return YunoSdkFoundationPlatform.instance.getPlatformVersion();
  }
}
