import 'package:flutter_test/flutter_test.dart';
import 'package:yuno_sdk_platform_interface/src/src.dart';

void main() {
  group('EnrollmentArguments', () {
    test('should correctly initialize properties', () {
      const args = EnrollmentArguments(
        customerSession: 'session_123',
        showPaymentStatus: false,
        countryCode: 'US',
      );

      expect(args.customerSession, 'session_123');
      expect(args.showPaymentStatus, false);
      expect(args.countryCode, 'US');
    });

    test('should correctly handle default values', () {
      const args = EnrollmentArguments(
        customerSession: 'session_456',
      );

      expect(args.customerSession, 'session_456');
      expect(args.showPaymentStatus, true); // Default value
      expect(args.countryCode, null);
    });

    test('should support equality operator for identical values', () {
      const args1 = EnrollmentArguments(
        customerSession: 'session_123',
        showPaymentStatus: false,
        countryCode: 'US',
      );

      const args2 = EnrollmentArguments(
        customerSession: 'session_123',
        showPaymentStatus: false,
        countryCode: 'US',
      );

      expect(args1 == args2, true); // Equal
    });

    test('should support equality operator for different values', () {
      const args1 = EnrollmentArguments(
        customerSession: 'session_123',
        showPaymentStatus: false,
        countryCode: 'US',
      );

      const args2 = EnrollmentArguments(
        customerSession: 'session_123',
        showPaymentStatus: true, // Different value
        countryCode: 'US',
      );

      expect(args1 == args2, false); // Not equal
    });

    test('should handle self-comparison correctly', () {
      const args = EnrollmentArguments(
        customerSession: 'session_123',
        showPaymentStatus: false,
        countryCode: 'US',
      );

      expect(args == args, true); // Equal
    });

    test('should generate consistent hashCode', () {
      const args1 = EnrollmentArguments(
        customerSession: 'session_123',
        showPaymentStatus: false,
        countryCode: 'US',
      );

      const args2 = EnrollmentArguments(
        customerSession: 'session_123',
        showPaymentStatus: false,
        countryCode: 'US',
      );

      expect(args1.hashCode, args2.hashCode); // Equal hashCode
    });

    test('should generate different hashCodes for different objects', () {
      const args1 = EnrollmentArguments(
        customerSession: 'session_123',
        showPaymentStatus: false,
        countryCode: 'US',
      );

      const args2 = EnrollmentArguments(
        customerSession: 'session_789', // Different value
        showPaymentStatus: true,
        countryCode: 'CA',
      );

      expect(args1.hashCode, isNot(args2.hashCode)); // Different hashCode
    });
  });
}
