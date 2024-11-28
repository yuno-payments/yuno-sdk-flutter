import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yuno_sdk_core/commons/src/enums/yuno_language.dart';
import 'package:yuno_sdk_platform_interface/yuno_sdk_platform_interface.dart';

class MockMethodChannel extends Mock implements MethodChannel {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('YunoMethodChannel Tests', () {
    late MethodChannel methodChannel;
    late YunoMethodChannel yunoMethodChannel;
    late YunoPaymentNotifier yunoController;
    late YunoEnrollmentNotifier yunoEnrollmentNotifier;

    setUp(() {
      methodChannel = const MethodChannel('test_channel');
      yunoController = YunoPaymentNotifier();
      yunoEnrollmentNotifier = YunoEnrollmentNotifier();
    });

    test('isIos getter should return true when platformIsIos is true', () {
      yunoMethodChannel = YunoMethodChannel(
        yunoNotifier: yunoController,
        methodChannel: methodChannel,
        platformIsIos: true,
        platformIsAndroid: false,
        yunoEnrollmentNotifier: yunoEnrollmentNotifier,
      );

      expect(yunoMethodChannel.isIos, isTrue);
    });

    test('isIos getter should return false when platformIsIos is false', () {
      yunoMethodChannel = YunoMethodChannel(
        yunoNotifier: yunoController,
        methodChannel: methodChannel,
        platformIsIos: false,
        platformIsAndroid: true,
        yunoEnrollmentNotifier: yunoEnrollmentNotifier,
      );

      expect(yunoMethodChannel.isIos, isFalse);
    });

    test('isAndroid getter should return true when platformIsAndroid is true',
        () {
      yunoMethodChannel = YunoMethodChannel(
        yunoNotifier: yunoController,
        methodChannel: methodChannel,
        platformIsIos: false,
        platformIsAndroid: true,
        yunoEnrollmentNotifier: yunoEnrollmentNotifier,
      );

      expect(yunoMethodChannel.isAndroid, isTrue);
    });

    test('isAndroid getter should return false when platformIsAndroid is false',
        () {
      yunoMethodChannel = YunoMethodChannel(
        yunoNotifier: yunoController,
        methodChannel: methodChannel,
        platformIsIos: true,
        platformIsAndroid: false,
        yunoEnrollmentNotifier: yunoEnrollmentNotifier,
      );

      expect(yunoMethodChannel.isAndroid, isFalse);
    });

    test(
        'initialize should invoke the method channel with correct parameters for Android',
        () async {
      yunoMethodChannel = YunoMethodChannel(
        yunoNotifier: yunoController,
        methodChannel: methodChannel,
        platformIsIos: false,
        platformIsAndroid: true,
        yunoEnrollmentNotifier: yunoEnrollmentNotifier,
      );

      const apiKey = 'test_api_key';
      const countryCode = 'country_code';
      const cardFlow = CardFlow.oneStep;
      const saveCardEnable = false;
      const isDynamicViewEnable = false;
      const keepLoader = false;
      const lang = YunoLanguage.en;
      const yunoConfig = YunoConfig(
        cardFlow: cardFlow,
        saveCardEnable: saveCardEnable,
        isDynamicViewEnable: isDynamicViewEnable,
        keepLoader: keepLoader,
        lang: lang,
      );
      const androidConfig = AndroidConfig();

      bool methodCalled = false;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(methodChannel,
              (MethodCall methodCall) async {
        methodCalled = true;

        expect(methodCall.method, 'initialize');
        expect(methodCall.arguments, {
          'apiKey': apiKey,
          'countryCode': countryCode,
          'yunoConfig': yunoConfig.toMap(),
          'configuration': null,
        });

        return null;
      });

      await yunoMethodChannel.initialize(
        apiKey: apiKey,
        countryCode: countryCode,
        androidConfig: androidConfig,
        yunoConfig: yunoConfig,
      );

      expect(methodCalled, isTrue);
    });

    test(
        'initialize should invoke the method channel with correct parameters for iOS',
        () async {
      yunoMethodChannel = YunoMethodChannel(
        yunoNotifier: yunoController,
        methodChannel: methodChannel,
        platformIsIos: true,
        platformIsAndroid: false,
        yunoEnrollmentNotifier: yunoEnrollmentNotifier,
      );

      const apiKey = 'test_api_key';
      const countryCode = 'country_code';
      const iosConfig = IosConfig();
      const cardFlow = CardFlow.oneStep;
      const saveCardEnable = false;
      const isDynamicViewEnable = false;
      const keepLoader = false;
      const lang = YunoLanguage.en;
      const yunoConfig = YunoConfig(
        cardFlow: cardFlow,
        saveCardEnable: saveCardEnable,
        isDynamicViewEnable: isDynamicViewEnable,
        lang: lang,
        keepLoader: keepLoader,
      );

      bool methodCalled = false;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(methodChannel,
              (MethodCall methodCall) async {
        methodCalled = true;

        expect(methodCall.method, 'initialize');
        expect(methodCall.arguments, {
          'apiKey': apiKey,
          'countryCode': countryCode,
          'yunoConfig': yunoConfig.toMap(),
          'configuration': iosConfig.toMap(),
        });

        return null;
      });

      await yunoMethodChannel.initialize(
        apiKey: apiKey,
        countryCode: countryCode,
        iosConfig: iosConfig,
        yunoConfig: yunoConfig,
      );

      expect(methodCalled, isTrue);
    });
  });

  test('Factory creates YunoMethodChannel with correct platform flags', () {
    // Factory should set the correct platform flags
    YunoMethodChannelFactory factory = const YunoMethodChannelFactory();

    if (Platform.isIOS) {
      YunoPlatform instance = factory.create();
      expect(instance is YunoMethodChannel, true);
      final yuno = instance as YunoMethodChannel;
      expect(yuno.isIos, true);
      expect(yuno.isAndroid, false);
    } else if (Platform.isAndroid) {
      YunoPlatform instance = factory.create();
      expect(instance is YunoMethodChannel, true);
      final yuno = instance as YunoMethodChannel;
      expect(yuno.isIos, false);
      expect(yuno.isAndroid, true);
    }
  });
}
