import 'package:flutter_test/flutter_test.dart';
import 'package:yuno_sdk_platform_interface/src/src.dart';

void main() {
  group('PaymentMethodsParser.toMap', () {
    test('should correctly convert PaymentMethodConf with countryCode to map',
        () {
      const conf = PaymentMethodConf(
        checkoutSession: 'session_123',
        countryCode: 'CA',
      );

      final result = conf.toMap(currentWidth: 320.0);

      expect(result, {
        'checkoutSession': 'session_123',
        'countryCode': 'CA', // Explicitly provided countryCode
        'width': 320.0,
      });
    });

    test('should correctly use default countryCode if not provided', () {
      const conf = PaymentMethodConf(
        checkoutSession: 'session_456',
        countryCode: 'US',
      );

      final result = conf.toMap(currentWidth: 480.0);

      expect(result, {
        'checkoutSession': 'session_456',
        'countryCode': 'US', // Default from YunoSharedSingleton
        'width': 480.0,
      });
    });

    test('should correctly convert with different width values', () {
      const conf = PaymentMethodConf(
        checkoutSession: 'session_789',
        countryCode: 'UK',
      );

      final result = conf.toMap(currentWidth: 1024.0);

      expect(result, {
        'checkoutSession': 'session_789',
        'countryCode': 'UK',
        'width': 1024.0,
      });
    });

    test('should handle missing countryCode and no default value', () {
      const conf = PaymentMethodConf(
        checkoutSession: 'session_000',
      );

      final result = conf.toMap(currentWidth: 200.0);

      expect(result, {
        'checkoutSession': 'session_000',
        'countryCode': null, // No default available
        'width': 200.0,
      });
    });
  });
}
