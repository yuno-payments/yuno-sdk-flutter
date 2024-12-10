import 'package:flutter_test/flutter_test.dart';

import 'package:yuno_sdk_platform_interface/src/src.dart';

void main() {
  group('EnrollmentArgumentsParser', () {
    test('should correctly convert EnrollmentArguments to Map', () {
      const args = EnrollmentArguments(
        customerSession: 'session_123',
        countryCode: 'US',
        showPaymentStatus: false,
      );

      final result = args.toMap();

      expect(result, {
        'countryCode': 'US',
        'customerSession': 'session_123',
        'showPaymentStatus': false,
      });
    });

    test('should handle null countryCode correctly', () {
      const args = EnrollmentArguments(
        customerSession: 'session_456',
        showPaymentStatus: true,
      );

      final result = args.toMap();

      expect(result, {
        'countryCode': null,
        'customerSession': 'session_456',
        'showPaymentStatus': true,
      });
    });

    test('should produce consistent results for identical objects', () {
      const args1 = EnrollmentArguments(
        customerSession: 'session_123',
        countryCode: 'US',
        showPaymentStatus: true,
      );

      const args2 = EnrollmentArguments(
        customerSession: 'session_123',
        countryCode: 'US',
        showPaymentStatus: true,
      );

      expect(args1.toMap(), args2.toMap());
    });
  });
}
