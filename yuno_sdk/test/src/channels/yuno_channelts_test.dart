import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yuno/yuno.dart';
import 'package:yuno_sdk_platform_interface/lib.dart';
import '../utils/mock_yuno_platform.dart';

void main() {
  late MockYunoPlatform mockPlatform;

  setUpAll(() {
    mockPlatform = MockYunoPlatform();
    YunoPlatform.instance = mockPlatform;
    registerFallbackValue(const IosConfig());
    registerFallbackValue(const AndroidConfig());
    registerFallbackValue(CardFlow.multiStep);
    registerFallbackValue(YunoLanguage.en);
    registerFallbackValue(const YunoConfig());
    registerFallbackValue(const PaymentMethodsArgs(checkoutSession: '1234'));
  });

  group('Yuno', () {
    test('init should call platform initialize', () async {
      when(() => mockPlatform.init()).thenAnswer((_) async {});
      when(() => mockPlatform.initialize(
            apiKey: any(named: 'apiKey'),
            yunoConfig: any(named: 'yunoConfig'),
            iosConfig: any(named: 'iosConfig'),
            androidConfig: any(named: 'androidConfig'),
          )).thenAnswer((_) async {});

      await Yuno.init(
        apiKey: 'test_api_key',
        countryCode: 'country_code',
      );

      verify(() => mockPlatform.initialize(
            apiKey: 'test_api_key',
            yunoConfig: any(named: 'yunoConfig'),
            iosConfig: const IosConfig(),
            androidConfig: const AndroidConfig(),
          )).called(1);
    });

//TODO: refactor the following test
    test(
        'openPaymentMethodsScreen should throw UnimplementedError for standard SDK',
        () async {
      final yuno = await Yuno.init(
        apiKey: 'test_api_key',
        countryCode: 'country_code',
      );

      expect(
          () => yuno.openPaymentMethodsScreen(
                arguments: any(named: 'argumens'),
              ),
          throwsA(isA<UnimplementedError>()));
    });
  });
}
