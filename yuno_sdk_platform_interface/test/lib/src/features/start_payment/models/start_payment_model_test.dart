import 'package:flutter_test/flutter_test.dart';
import 'package:yuno_sdk_platform_interface/src/features/start_payment/start_payment.dart';

void main() {
  group('StartPaymentModel', () {
    test('should correctly initialize with given values', () {
      const model = StartPaymentModel(
        checkoutSession: 'session_123',
        showPaymentStatus: true,
      );

      expect(model.checkoutSession, 'session_123');
      expect(model.showPaymentStatus, true);
    });

    test('should support equality for identical values', () {
      const model1 = StartPaymentModel(
        checkoutSession: 'session_123',
        showPaymentStatus: true,
      );

      const model2 = StartPaymentModel(
        checkoutSession: 'session_123',
        showPaymentStatus: true,
      );

      expect(model1 == model2, true); // Identical values should be equal
    });

    test('should support inequality for different checkoutSession values', () {
      const model1 = StartPaymentModel(
        checkoutSession: 'session_123',
        showPaymentStatus: true,
      );

      const model2 = StartPaymentModel(
        checkoutSession: 'session_456',
        showPaymentStatus: true,
      );

      expect(model1 == model2, false); // Different checkoutSession
    });

    test('should support inequality for different showPaymentStatus values',
        () {
      const model1 = StartPaymentModel(
        checkoutSession: 'session_123',
        showPaymentStatus: true,
      );

      const model2 = StartPaymentModel(
        checkoutSession: 'session_123',
        showPaymentStatus: false,
      );

      expect(model1 == model2, false); // Different showPaymentStatus
    });

    test('should generate consistent hashCode for identical values', () {
      const model1 = StartPaymentModel(
        checkoutSession: 'session_123',
        showPaymentStatus: true,
      );

      const model2 = StartPaymentModel(
        checkoutSession: 'session_123',
        showPaymentStatus: true,
      );

      expect(model1.hashCode,
          model2.hashCode); // Identical values should have the same hashCode
    });

    test('should generate different hashCodes for different values', () {
      const model1 = StartPaymentModel(
        checkoutSession: 'session_123',
        showPaymentStatus: true,
      );

      const model2 = StartPaymentModel(
        checkoutSession: 'session_456',
        showPaymentStatus: true,
      );

      expect(
          model1.hashCode,
          isNot(model2
              .hashCode)); // Different values should have different hashCodes
    });

    test('should handle self-comparison correctly', () {
      const model = StartPaymentModel(
        checkoutSession: 'session_123',
        showPaymentStatus: true,
      );

      expect(model == model, true); // An object should always equal itself
    });
  });
}
