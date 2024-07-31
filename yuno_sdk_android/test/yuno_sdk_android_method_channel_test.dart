import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yuno_sdk_android/yuno_sdk_android_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelYunoSdkAndroid platform = MethodChannelYunoSdkAndroid();
  const MethodChannel channel = MethodChannel('yuno_sdk_android');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
