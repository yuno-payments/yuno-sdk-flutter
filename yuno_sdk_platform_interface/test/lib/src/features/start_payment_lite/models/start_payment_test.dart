import 'package:flutter_test/flutter_test.dart';
import 'package:yuno_sdk_platform_interface/src/src.dart';

void main() {
  group('StartPayment', () {
    test('should correctly initialize with default values', () {
      const method = MethodSelected(
        paymentMethodType: 'sample',
      );
      const startPayment = StartPayment(
        checkoutSession: 'session_123',
        methodSelected: method,
      );

      expect(startPayment.showPaymentStatus, true); // Default value
      expect(startPayment.checkoutSession, 'session_123');
      expect(startPayment.methodSelected, method);
    });

    test('should correctly initialize with custom values', () {
      const method = MethodSelected(
        paymentMethodType: 'sample',
      );
      const startPayment = StartPayment(
        showPaymentStatus: false,
        checkoutSession: 'session_456',
        methodSelected: method,
      );

      expect(startPayment.showPaymentStatus, false);
      expect(startPayment.checkoutSession, 'session_456');
      expect(startPayment.methodSelected, method);
    });

    test('should support equality operator for identical values', () {
      const method = MethodSelected(
        paymentMethodType: 'sample',
      );
      const payment1 = StartPayment(
        checkoutSession: 'session_123',
        methodSelected: method,
      );
      const payment2 = StartPayment(
        checkoutSession: 'session_123',
        methodSelected: method,
      );

      expect(payment1 == payment2, true); // Equal
    });

    test('should support inequality for different showPaymentStatus', () {
      const method = MethodSelected(
        paymentMethodType: 'sample',
      );
      const payment1 = StartPayment(
        showPaymentStatus: true,
        checkoutSession: 'session_123',
        methodSelected: method,
      );
      const payment2 = StartPayment(
        showPaymentStatus: false,
        checkoutSession: 'session_123',
        methodSelected: method,
      );

      expect(payment1 == payment2, false); // Not equal
    });

    test('should support inequality for different methodSelected', () {
      const method1 = MethodSelected(
        paymentMethodType: 'sample',
      );
      const method2 = MethodSelected(
        paymentMethodType: 'sampl2',
      );
      const payment1 = StartPayment(
        checkoutSession: 'session_123',
        methodSelected: method1,
      );
      const payment2 = StartPayment(
        checkoutSession: 'session_123',
        methodSelected: method2,
      );

      expect(payment1 == payment2, false); // Not equal
    });

    test('should generate consistent hashCode for identical values', () {
      const method = MethodSelected(
        paymentMethodType: 'sample',
      );
      const payment1 = StartPayment(
        checkoutSession: 'session_123',
        methodSelected: method,
      );
      const payment2 = StartPayment(
        checkoutSession: 'session_123',
        methodSelected: method,
      );

      expect(payment1.hashCode, payment2.hashCode); // Same hashCode
    });

    test('should generate different hashCodes for different values', () {
      const method1 = MethodSelected(
        paymentMethodType: 'sample',
      );
      const method2 = MethodSelected(
        paymentMethodType: 'sampl2',
      );
      const payment1 = StartPayment(
        checkoutSession: 'session_123',
        methodSelected: method1,
      );
      const payment2 = StartPayment(
        checkoutSession: 'session_123',
        methodSelected: method2,
      );

      expect(
          payment1.hashCode, isNot(payment2.hashCode)); // Different hashCodes
    });

    test('should correctly convert to map', () {
      const method = MethodSelected(
        paymentMethodType: 'sample',
      );
      const payment = StartPayment(
        checkoutSession: 'session_123',
        methodSelected: method,
      );

      final result = payment.toMap(countryCode: 'US');

      expect(result, {
        'countryCode': 'US',
        'showPaymentStatus': true,
        'checkoutSession': 'session_123',
        'paymentMethodSelected': {
          'vaultedToken': null,
          'paymentMethodType': 'sample',
        },
      });
    });

    test('should assert that paymentMethodType is not empty', () {
      expect(() => MethodSelected(paymentMethodType: ""),
          throwsA(isA<AssertionError>()));

      const validMethodSelected = MethodSelected(
        paymentMethodType: "credit_card",
        vaultedToken: "abc123",
      );

      expect(validMethodSelected.paymentMethodType, "credit_card");
      expect(validMethodSelected.vaultedToken, "abc123");
    });

    test('should return correct string representation', () {
      const method = MethodSelected(
        paymentMethodType: 'sample',
      );
      const payment = StartPayment(
        checkoutSession: 'session_123',
        methodSelected: method,
      );

      expect(
        payment.toString(),
        'StartPayment(showPaymentStatus: ${payment.showPaymentStatus}, paymentMethod: $method)',
      );
    });
  });
}
