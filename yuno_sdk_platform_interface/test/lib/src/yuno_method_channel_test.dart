import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yuno_sdk_platform_interface/lib.dart';

class MockMethodChannel extends Mock implements MethodChannel {}

void main() {
  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  group('YunoMethodChannel', () {
    late MockMethodChannel mockMethodChannel;
    late YunoMethodChannel yunoMethodChannel;

    setUp(() {
      mockMethodChannel = MockMethodChannel();
    });

    test('isIos should return true when platform is iOS', () {
      yunoMethodChannel = YunoMethodChannel(
        methodChannel: mockMethodChannel,
        platformIsIos: true,
        platformIsAndroid: false,
      );

      expect(yunoMethodChannel.isIos, true);
      expect(yunoMethodChannel.isAndroid, false);
    });

    test('isAndroid should return true when platform is Android', () {
      yunoMethodChannel = YunoMethodChannel(
        methodChannel: mockMethodChannel,
        platformIsIos: false,
        platformIsAndroid: true,
      );

      expect(yunoMethodChannel.isIos, false);
      expect(yunoMethodChannel.isAndroid, true);
    });

    test(
        'initialize should call invokeMethod with correct arguments on Android',
        () async {
      yunoMethodChannel = YunoMethodChannel(
        methodChannel: mockMethodChannel,
        platformIsIos: false,
        platformIsAndroid: true,
      );

      const androidConfig = AndroidConfig();
      final expectedArgs = {
        'apiKey': 'testApiKey',
        'countryCode': 'US',
        'configuration': androidConfig.toMap(),
      };

      when(() => mockMethodChannel.invokeMethod('initialize', any()))
          .thenAnswer((_) async {});

      await yunoMethodChannel.initialize(
        apiKey: 'testApiKey',
        countryCode: 'US',
        androidConfig: androidConfig,
      );

      verify(() => mockMethodChannel.invokeMethod('initialize', expectedArgs))
          .called(1);
    });

    test('initialize should call invokeMethod with correct arguments on iOS',
        () async {
      yunoMethodChannel = YunoMethodChannel(
        methodChannel: mockMethodChannel,
        platformIsIos: true,
        platformIsAndroid: false,
      );

      const iosConfig = IosConfig();
      final expectedArgs = {
        'apiKey': 'testApiKey',
        'countryCode': 'US',
        'configuration': iosConfig.toMap(),
      };

      when(() => mockMethodChannel.invokeMethod('initialize', any()))
          .thenAnswer((_) async {});

      await yunoMethodChannel.initialize(
        apiKey: 'testApiKey',
        countryCode: 'US',
        iosConfig: iosConfig,
      );

      verify(() => mockMethodChannel.invokeMethod('initialize', expectedArgs))
          .called(1);
    });
  });
}
