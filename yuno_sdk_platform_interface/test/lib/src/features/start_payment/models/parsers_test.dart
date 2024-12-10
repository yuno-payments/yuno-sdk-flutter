import 'package:flutter_test/flutter_test.dart';
import 'package:yuno_sdk_platform_interface/src/features/start_payment/models/parsers.dart';

void main() {
  group('ParserStartPayment.toMap', () {
    test('should correctly convert showPaymentStatus to map when true', () {
      // Act
      final result = ParserStartPayment.toMap(showPaymentStatus: true);

      // Assert
      expect(result, {
        'showPaymentStatus': true,
      });
    });

    test('should correctly convert showPaymentStatus to map when false', () {
      // Act
      final result = ParserStartPayment.toMap(showPaymentStatus: false);

      // Assert
      expect(result, {
        'showPaymentStatus': false,
      });
    });

    test('should generate consistent map output for the same input', () {
      // Act
      final result1 = ParserStartPayment.toMap(showPaymentStatus: true);
      final result2 = ParserStartPayment.toMap(showPaymentStatus: true);

      // Assert
      expect(result1, result2); // Maps with the same input should be identical
    });

    test('should generate different map outputs for different inputs', () {
      // Act
      final result1 = ParserStartPayment.toMap(showPaymentStatus: true);
      final result2 = ParserStartPayment.toMap(showPaymentStatus: false);

      // Assert
      expect(
          result1, isNot(result2)); // Maps with different inputs should differ
    });

    test('should handle edge cases gracefully', () {
      // Verify that the method works with the required input
      expect(
        ParserStartPayment.toMap(showPaymentStatus: true),
        isA<Map<String, dynamic>>(),
      );
    });
  });
}
