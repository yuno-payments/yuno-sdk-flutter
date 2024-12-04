import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:yuno_sdk_platform_interface/src/src.dart';

void main() {
  group('Appearance', () {
    test('should correctly compare fontFamily', () {
      const appearance1 = Appearance(fontFamily: 'Arial');
      const appearance2 = Appearance(fontFamily: 'Arial');
      const appearance3 = Appearance(fontFamily: 'Helvetica');

      expect(appearance1 == appearance2, true); // Same fontFamily
      expect(appearance1 == appearance3, false); // Different fontFamily
    });

    test('should correctly compare accentColor', () {
      const appearance1 = Appearance(accentColor: Color(0xFF0000FF));
      const appearance2 = Appearance(accentColor: Color(0xFF0000FF));
      const appearance3 = Appearance(accentColor: Color(0xFFFF0000));

      expect(appearance1 == appearance2, true); // Same accentColor
      expect(appearance1 == appearance3, false); // Different accentColor
    });

    test('should correctly compare buttonBackgrounColor', () {
      const appearance1 = Appearance(buttonBackgrounColor: Color(0xFF00FF00));
      const appearance2 = Appearance(buttonBackgrounColor: Color(0xFF00FF00));
      const appearance3 = Appearance(buttonBackgrounColor: Color(0xFFFF0000));

      expect(appearance1 == appearance2, true); // Same buttonBackgrounColor
      expect(
          appearance1 == appearance3, false); // Different buttonBackgrounColor
    });

    test('should correctly compare buttonTitleBackgrounColor', () {
      const appearance1 =
          Appearance(buttonTitleBackgrounColor: Color(0xFF00FF00));
      const appearance2 =
          Appearance(buttonTitleBackgrounColor: Color(0xFF00FF00));
      const appearance3 =
          Appearance(buttonTitleBackgrounColor: Color(0xFFFF0000));

      expect(
          appearance1 == appearance2, true); // Same buttonTitleBackgrounColor
      expect(appearance1 == appearance3,
          false); // Different buttonTitleBackgrounColor
    });

    test('should correctly compare checkboxColor', () {
      const appearance1 = Appearance(checkboxColor: Color(0xFF000000));
      const appearance2 = Appearance(checkboxColor: Color(0xFF000000));
      const appearance3 = Appearance(checkboxColor: Color(0xFFFFFFFF));

      expect(appearance1 == appearance2, true); // Same checkboxColor
      expect(appearance1 == appearance3, false); // Different checkboxColor
    });

    test('should correctly compare all properties', () {
      const appearance1 = Appearance(
        fontFamily: 'Arial',
        accentColor: Color(0xFF0000FF),
        buttonBackgrounColor: Color(0xFF00FF00),
        buttonTitleBackgrounColor: Color(0xFFFF0000),
        checkboxColor: Color(0xFF000000),
      );

      const appearance2 = Appearance(
        fontFamily: 'Arial',
        accentColor: Color(0xFF0000FF),
        buttonBackgrounColor: Color(0xFF00FF00),
        buttonTitleBackgrounColor: Color(0xFFFF0000),
        checkboxColor: Color(0xFF000000),
      );

      const appearance3 = Appearance(
        fontFamily: 'Helvetica', // Different fontFamily
        accentColor: Color(0xFFFF0000), // Different accentColor
        buttonBackgrounColor:
            Color(0xFF0000FF), // Different buttonBackgrounColor
        buttonTitleBackgrounColor:
            Color(0xFF00FF00), // Different buttonTitleBackgrounColor
        checkboxColor: Color(0xFFFFFFFF), // Different checkboxColor
      );

      expect(appearance1 == appearance2, true); // Equal
      expect(appearance1 == appearance3, false); // Not equal
    });
  });
  group('IosConfig', () {
    test('should correctly initialize with default values', () {
      const config = IosConfig();

      expect(config.appearance, null); // Default value
    });

    test('should correctly initialize with custom appearance', () {
      const appearance = Appearance(
        fontFamily: 'Helvetica',
        accentColor: Color(0xFF0000FF),
      );

      const config = IosConfig(appearance: appearance);

      expect(config.appearance, appearance);
    });

    test('should support equality operator for identical values', () {
      const appearance = Appearance(
        fontFamily: 'Helvetica',
        accentColor: Color(0xFF0000FF),
      );

      const config1 = IosConfig(appearance: appearance);
      const config2 = IosConfig(appearance: appearance);

      expect(config1 == config2, true); // Equal
    });

    test('should support equality operator for different values', () {
      const appearance1 = Appearance(
        fontFamily: 'Helvetica',
        accentColor: Color(0xFF0000FF),
      );

      const appearance2 = Appearance(
        fontFamily: 'Arial',
        accentColor: Color(0xFF00FF00),
      );

      const config1 = IosConfig(appearance: appearance1);
      const config2 = IosConfig(appearance: appearance2);

      expect(config1 == config2, false); // Not equal
    });

    test('should generate consistent hashCode for identical values', () {
      const appearance = Appearance(
        fontFamily: 'Helvetica',
        accentColor: Color(0xFF0000FF),
      );

      const config1 = IosConfig(appearance: appearance);
      const config2 = IosConfig(appearance: appearance);

      expect(config1.hashCode, config2.hashCode); // Equal hashCode
    });

    test('should generate different hashCodes for different values', () {
      const appearance1 = Appearance(
        fontFamily: 'Helvetica',
        accentColor: Color(0xFF0000FF),
      );

      const appearance2 = Appearance(
        fontFamily: 'Arial',
        accentColor: Color(0xFF00FF00),
      );

      const config1 = IosConfig(appearance: appearance1);
      const config2 = IosConfig(appearance: appearance2);

      expect(config1.hashCode, isNot(config2.hashCode)); // Different hashCode
    });
  });

  group('Appearance', () {
    test('should correctly initialize with default values', () {
      const appearance = Appearance();

      expect(appearance.fontFamily, null);
      expect(appearance.accentColor, null);
    });

    test('should correctly initialize with custom values', () {
      const appearance = Appearance(
        fontFamily: 'Helvetica',
        accentColor: Color(0xFF0000FF),
      );

      expect(appearance.fontFamily, 'Helvetica');
      expect(appearance.accentColor, const Color(0xFF0000FF));
    });

    test('should support equality operator for identical values', () {
      const appearance1 = Appearance(
        fontFamily: 'Helvetica',
        accentColor: Color(0xFF0000FF),
      );

      const appearance2 = Appearance(
        fontFamily: 'Helvetica',
        accentColor: Color(0xFF0000FF),
      );

      expect(appearance1 == appearance2, true); // Equal
    });

    test('should support equality operator for different values', () {
      const appearance1 = Appearance(
        fontFamily: 'Helvetica',
        accentColor: Color(0xFF0000FF),
      );

      const appearance2 = Appearance(
        fontFamily: 'Arial',
        accentColor: Color(0xFF00FF00),
      );

      expect(appearance1 == appearance2, false); // Not equal
    });

    test('should generate consistent hashCode for identical values', () {
      const appearance1 = Appearance(
        fontFamily: 'Helvetica',
        accentColor: Color(0xFF0000FF),
      );

      const appearance2 = Appearance(
        fontFamily: 'Helvetica',
        accentColor: Color(0xFF0000FF),
      );

      expect(appearance1.hashCode, appearance2.hashCode); // Equal hashCode
    });

    test('should generate different hashCodes for different values', () {
      const appearance1 = Appearance(
        fontFamily: 'Helvetica',
        accentColor: Color(0xFF0000FF),
      );

      const appearance2 = Appearance(
        fontFamily: 'Arial',
        accentColor: Color(0xFF00FF00),
      );

      expect(appearance1.hashCode,
          isNot(appearance2.hashCode)); // Different hashCode
    });
  });
}
