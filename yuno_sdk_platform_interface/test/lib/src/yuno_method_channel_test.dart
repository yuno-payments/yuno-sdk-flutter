import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yuno_sdk_platform_interface/lib.dart';

void main() {
  group('YunoMethodChannel Tests', () {
    late MethodChannel methodChannel;
    late YunoMethodChannel yunoMethodChannel;

    setUp(() {
      methodChannel = const MethodChannel('yuno/payments');
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

    test('liteInitialize throws UnimplementedError', () {
      yunoMethodChannel = YunoMethodChannel(
        methodChannel: methodChannel,
        platformIsIos: false,
        platformIsAndroid: true,
      );

      expect(() => yunoMethodChannel.initialize(apiKey: ''),
          throwsUnimplementedError);
    });

    test('fullInitialize throws UnimplementedError', () {
      yunoMethodChannel = YunoMethodChannel(
        methodChannel: methodChannel,
        platformIsIos: true,
        platformIsAndroid: false,
      );

      expect(() => yunoMethodChannel.initialize(apiKey: ''),
          throwsUnimplementedError);
    });
  });
}
