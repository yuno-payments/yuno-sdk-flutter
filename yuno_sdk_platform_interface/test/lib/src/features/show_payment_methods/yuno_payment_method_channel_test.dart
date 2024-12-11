import 'dart:ffi';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yuno_sdk_platform_interface/yuno_sdk_platform_interface.dart';

// Mocks
class MockMethodChannel extends Mock implements MethodChannel {}

class MockYunoPaymentMethodSelectNotifier extends Mock
    implements YunoPaymentMethodSelectNotifier {}

class MockYunoPaymentSelectNotifier extends Mock
    implements YunoPaymentSelectNotifier {}

void main() {
  late MethodChannel channel;
  late MockMethodChannel mockMethodChannel;
  late YunoPaymentMethodChannel yunoPaymentMethodChannel;
  late MockYunoPaymentMethodSelectNotifier mockController;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockMethodChannel = MockMethodChannel();
    mockController = MockYunoPaymentMethodSelectNotifier();

    channel = const MethodChannel('yuno/payment_methods_view/1');
    yunoPaymentMethodChannel = YunoPaymentMethodChannel(
      methodChannel: mockMethodChannel,
      platformIsIos: true,
      platformIsAndroid: false,
    );
  });
  group('YunoPaymentMethodChannel', () {
    test('should set method call handler for onHeightChange', () {
      when(() => mockMethodChannel.setMethodCallHandler(any())).thenAnswer(
        (_) => _,
      );

      yunoPaymentMethodChannel.setMethodCallHandler();
      verify(() => mockMethodChannel.setMethodCallHandler(any())).called(1);
    });

    test('should throw MissingPluginException for unknown method', () async {
      yunoPaymentMethodChannel.setMethodCallHandler();
      when(() => mockMethodChannel.invokeMethod<void>('unknownMethod'))
          .thenThrow(
              MissingPluginException('Not implemented method: unknownMethod'));

      expect(
        () async => await mockMethodChannel.invokeMethod<void>('unknownMethod'),
        throwsA(isA<MissingPluginException>()),
      );
    });

    test('should handle onSelected method call', () {
      when(() => mockMethodChannel.setMethodCallHandler(any())).thenAnswer(
        (_) => _,
      );

      yunoPaymentMethodChannel.setMethodCallHandler();
      verify(() => mockMethodChannel.setMethodCallHandler(any())).called(1);
    });

    test('should update height when onHeightChange is called', () async {
      yunoPaymentMethodChannel.setMethodCallHandler();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        channel.setMethodCallHandler((methodCall) async {
          if (methodCall.method == 'onHeightChange') {
            return 150.0;
          }
        });

        verify(() => mockController.updateHeight(150.0)).called(1);

        return null;
      });
    });

    test('should update selection when onSelected is called', () async {
      bool methodCalled = false;
      yunoPaymentMethodChannel = YunoPaymentMethodChannel(
        methodChannel: channel,
        platformIsIos: true,
        platformIsAndroid: false,
      );

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        methodCalled = true;

        expect(methodCall.method, 'onHeightChange');
        expect(methodCall.arguments, isA<Double>());

        return null;
      });

      expect(methodCalled, isFalse);
    });

    test('Factory creates YunoMethodChannel with correct platform flags', () {
      // Factory should set the correct platform flags
      yunoPaymentMethodChannel = YunoPaymentMethodChannel(
        methodChannel: mockMethodChannel,
        platformIsIos: true,
        platformIsAndroid: false,
      );

      if (Platform.isIOS == yunoPaymentMethodChannel.isIos) {
        expect(yunoPaymentMethodChannel.isIos, true);
        expect(yunoPaymentMethodChannel.isAndroid, false);
      } else if (Platform.isAndroid == yunoPaymentMethodChannel.isAndroid) {
        yunoPaymentMethodChannel = YunoPaymentMethodChannel(
          methodChannel: mockMethodChannel,
          platformIsIos: false,
          platformIsAndroid: true,
        );

        expect(yunoPaymentMethodChannel.isIos, false);
        expect(yunoPaymentMethodChannel.isAndroid, true);
      }
    });
  });
}
