import 'package:flutter_test/flutter_test.dart';
import 'package:yuno_sdk_platform_interface/yuno_sdk_platform_interface.dart';
import 'package:yuno_sdk_platform_interface/yuno_sdk_platform_interface_platform_interface.dart';
import 'package:yuno_sdk_platform_interface/yuno_sdk_platform_interface_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockYunoSdkPlatformInterfacePlatform
    with MockPlatformInterfaceMixin
    implements YunoSdkPlatformInterfacePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final YunoSdkPlatformInterfacePlatform initialPlatform = YunoSdkPlatformInterfacePlatform.instance;

  test('$MethodChannelYunoSdkPlatformInterface is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelYunoSdkPlatformInterface>());
  });

  test('getPlatformVersion', () async {
    YunoSdkPlatformInterface yunoSdkPlatformInterfacePlugin = YunoSdkPlatformInterface();
    MockYunoSdkPlatformInterfacePlatform fakePlatform = MockYunoSdkPlatformInterfacePlatform();
    YunoSdkPlatformInterfacePlatform.instance = fakePlatform;

    expect(await yunoSdkPlatformInterfacePlugin.getPlatformVersion(), '42');
  });
}
