import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:yuno_sdk_platform_interface/lib.dart';

class MockYunoPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements YunoPlatform {}
