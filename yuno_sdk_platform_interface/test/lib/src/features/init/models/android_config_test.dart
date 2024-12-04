import 'package:flutter_test/flutter_test.dart';
import 'package:yuno_sdk_platform_interface/src/src.dart';

void main() {
  group('AndroidConfig', () {
    test('should correctly initialize with default values', () {
      const config = AndroidConfig();

      expect(config.cardFormDeployed, false); // Default value
    });

    test('should correctly initialize with custom values', () {
      const config = AndroidConfig(cardFormDeployed: true);

      expect(config.cardFormDeployed, true); // Custom value
    });

    test('should support equality operator for identical values', () {
      const config1 = AndroidConfig(cardFormDeployed: false);
      const config2 = AndroidConfig(cardFormDeployed: false);

      expect(config1 == config2, true); // Equal
    });

    test('should support equality operator for different values', () {
      const config1 = AndroidConfig(cardFormDeployed: false);
      const config2 = AndroidConfig(cardFormDeployed: true);

      expect(config1 == config2, false); // Not equal
    });

    test('should handle self-comparison correctly', () {
      const config = AndroidConfig(cardFormDeployed: false);

      expect(config == config, true); // Equal
    });

    test('should generate consistent hashCode for identical values', () {
      const config1 = AndroidConfig(cardFormDeployed: false);
      const config2 = AndroidConfig(cardFormDeployed: false);

      expect(config1.hashCode, config2.hashCode); // Equal hashCode
    });

    test('should generate different hashCodes for different values', () {
      const config1 = AndroidConfig(cardFormDeployed: false);
      const config2 = AndroidConfig(cardFormDeployed: true);

      expect(config1.hashCode, isNot(config2.hashCode)); // Different hashCode
    });
  });
}
