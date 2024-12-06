import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:yuno_sdk_platform_interface/src/src.dart';

class SampleYunoPaymentMethodChannelFactory {
  const SampleYunoPaymentMethodChannelFactory();

  YunoPaymentMethodPlatform create({
    required int viewId,
  }) =>
      YunoPaymentMethodChannel(
        methodChannel: MethodChannel(
          'sample/$viewId',
        ),
        platformIsIos: Platform.isIOS,
        platformIsAndroid: Platform.isAndroid,
      );
}

// Mock classes
class MockYunoPaymentMethodPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements YunoPaymentMethodPlatform {}

class MockYunoPaymentMethodChannelFactory extends Mock
    implements SampleYunoPaymentMethodChannelFactory {}

class MockYunoPaymentMethodSelectNotifier extends Mock
    implements YunoPaymentMethodSelectNotifier {}

class MockYunoPaymentSelectNotifier extends Mock
    implements YunoPaymentSelectNotifier {}

void main() {
  group('YunoPaymentMethodPlatform', () {
    late MockYunoPaymentMethodPlatform mockPlatform;
    late MockYunoPaymentMethodChannelFactory mockFactory;

    setUp(() {
      mockPlatform = MockYunoPaymentMethodPlatform();
      mockFactory = MockYunoPaymentMethodChannelFactory();

      // Reset any previous interactions
      reset(mockPlatform);
      reset(mockFactory);
    });

    test('viewType returns correct string', () {
      // Assert
      expect(YunoPaymentMethodPlatform.viewType,
          equals('yuno/payment_methods_view'));
    });

    test('controller returns YunoPaymentMethodSelectNotifier', () {
      // Assert
      expect(YunoPaymentMethodPlatform.controller, isNotNull);
      expect(YunoPaymentMethodPlatform.controller,
          isA<YunoPaymentMethodSelectNotifier>());
    });

    test('selectController returns YunoPaymentSelectNotifier', () {
      // Assert
      expect(YunoPaymentMethodPlatform.selectController, isNotNull);
      expect(YunoPaymentMethodPlatform.selectController,
          isA<YunoPaymentSelectNotifier>());
    });

    test('setMethodCallHandler can be called', () {
      // Arrange
      when(() => mockPlatform.setMethodCallHandler()).thenReturn(null);

      // Act
      mockPlatform.setMethodCallHandler();

      // Assert
      verify(() => mockPlatform.setMethodCallHandler()).called(1);
    });
  });
}
