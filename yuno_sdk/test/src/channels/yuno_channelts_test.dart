import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yuno/yuno.dart';
import 'package:yuno_sdk_core/lib.dart';
import 'package:yuno_sdk_platform_interface/lib.dart';

import '../utils/mock_yuno_platform.dart';

void main() {
  late MockYunoPlatform mockPlatform;

  setUpAll(() {
    mockPlatform = MockYunoPlatform();
    YunoPlatform.instance = mockPlatform;
    registerFallbackValue(const IosConfig());
    registerFallbackValue(const AndroidConfig());
  });

  group('Yuno', () {
    test('init should call platform initialize', () async {
      when(() => mockPlatform.initialize(
            apiKey: any(named: 'apiKey'),
            iosConfig: any(named: 'iosConfig'),
            androidConfig: any(named: 'androidConfig'),
          )).thenAnswer((_) async {});

      await Yuno.init(
        apiKey: 'test_api_key',
        sdkType: YunoSdkType.full,
      );

      verify(() => mockPlatform.initialize(
            apiKey: 'test_api_key',
            iosConfig: const IosConfig(),
            androidConfig: const AndroidConfig(),
          )).called(1);
    });

    test('openPaymentMethodsScreen should throw YunoNotSupport for lite SDK',
        () async {
      final yuno = await Yuno.init(
        apiKey: 'test_api_key',
        sdkType: YunoSdkType.lite,
      );

      expect(() => yuno.openPaymentMethodsScreen(),
          throwsA(isA<YunoNotSupport>()));
    });

    test(
        'openPaymentMethodsScreen should throw UnimplementedError for standard SDK',
        () async {
      final yuno = await Yuno.init(
        apiKey: 'test_api_key',
        sdkType: YunoSdkType.full,
      );

      expect(() => yuno.openPaymentMethodsScreen(),
          throwsA(isA<UnimplementedError>()));
    });
  });
}
