import 'package:flutter_test/flutter_test.dart';
import 'package:yuno_sdk_platform_interface/src/src.dart';

void main() {
  group('PaymentMethodConf', () {
    test('should correctly initialize with default values', () {
      const conf = PaymentMethodConf(checkoutSession: 'session_123');

      expect(conf.checkoutSession, 'session_123');
      expect(conf.countryCode, null); // Default value for nullable field
      expect(conf.iosViewType, IOSViewType.separated); // Default value
    });

    test('should correctly initialize with custom values', () {
      const conf = PaymentMethodConf(
        checkoutSession: 'session_456',
        countryCode: 'US',
        iosViewType: IOSViewType.all,
      );

      expect(conf.checkoutSession, 'session_456');
      expect(conf.countryCode, 'US');
      expect(conf.iosViewType, IOSViewType.all);
    });

    test('should support equality operator for identical values', () {
      const conf1 = PaymentMethodConf(
        checkoutSession: 'session_123',
        countryCode: 'US',
        iosViewType: IOSViewType.separated,
      );

      const conf2 = PaymentMethodConf(
        checkoutSession: 'session_123',
        countryCode: 'US',
        iosViewType: IOSViewType.separated,
      );

      expect(conf1 == conf2, true); // Equal
    });

    test('should support equality operator for different values', () {
      const conf1 = PaymentMethodConf(
        checkoutSession: 'session_123',
        countryCode: 'US',
        iosViewType: IOSViewType.separated,
      );

      const conf2 = PaymentMethodConf(
        checkoutSession: 'session_456', // Different checkoutSession
        countryCode: 'US',
        iosViewType: IOSViewType.separated,
      );

      const conf3 = PaymentMethodConf(
        checkoutSession: 'session_123',
        countryCode: 'CA', // Different countryCode
        iosViewType: IOSViewType.separated,
      );

      const conf4 = PaymentMethodConf(
        checkoutSession: 'session_123',
        countryCode: 'US',
        iosViewType: IOSViewType.all, // Different iosViewType
      );

      expect(conf1 == conf2, false); // Not equal (checkoutSession)
      expect(conf1 == conf3, false); // Not equal (countryCode)
      expect(conf1 == conf4, false); // Not equal (iosViewType)
    });

    test('should handle self-comparison correctly', () {
      const conf = PaymentMethodConf(
        checkoutSession: 'session_123',
        countryCode: 'US',
        iosViewType: IOSViewType.separated,
      );

      expect(conf == conf, true); // Equal
    });

    test('should generate consistent hashCode for identical values', () {
      const conf1 = PaymentMethodConf(
        checkoutSession: 'session_123',
        countryCode: 'US',
        iosViewType: IOSViewType.separated,
      );

      const conf2 = PaymentMethodConf(
        checkoutSession: 'session_123',
        countryCode: 'US',
        iosViewType: IOSViewType.separated,
      );

      expect(conf1.hashCode, conf2.hashCode); // Equal hashCode
    });

    test('should generate different hashCodes for different values', () {
      const conf1 = PaymentMethodConf(
        checkoutSession: 'session_123',
        countryCode: 'US',
        iosViewType: IOSViewType.separated,
      );

      const conf2 = PaymentMethodConf(
        checkoutSession: 'session_456', // Different checkoutSession
        countryCode: 'US',
        iosViewType: IOSViewType.separated,
      );

      const conf3 = PaymentMethodConf(
        checkoutSession: 'session_123',
        countryCode: 'CA', // Different countryCode
        iosViewType: IOSViewType.separated,
      );

      const conf4 = PaymentMethodConf(
        checkoutSession: 'session_123',
        countryCode: 'US',
        iosViewType: IOSViewType.all, // Different iosViewType
      );

      expect(conf1.hashCode, isNot(conf2.hashCode)); // Different hashCode
      expect(conf1.hashCode, isNot(conf3.hashCode)); // Different hashCode
      expect(conf1.hashCode, isNot(conf4.hashCode)); // Different hashCode
    });
  });
}
