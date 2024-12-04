import 'package:flutter_test/flutter_test.dart';
import 'package:yuno_sdk_core/lib.dart';
import 'package:yuno_sdk_platform_interface/yuno_sdk_platform_interface.dart';
import 'dart:ui';

void main() {
  group('ParserIosConfig', () {
    test('should correctly convert IosConfig with null appearance to map', () {
      const iosConfig = IosConfig(appearance: null);

      final result = iosConfig.toMap();

      expect(result, {
        'appearance': null,
      });
    });

    test('should correctly convert IosConfig with appearance to map', () {
      const appearance = Appearance(fontFamily: 'Helvetica');
      const iosConfig = IosConfig(appearance: appearance);

      final result = iosConfig.toMap();

      expect(result, {
        'appearance': {
          'fontFamily': 'Helvetica',
          'accentColor': null,
          'buttonBackgrounColor': null,
          'buttonTitleBackgrounColor': null,
          'buttonBorderBackgrounColor': null,
          'secondaryButtonBackgrounColor': null,
          'secondaryButtonTitleBackgrounColor': null,
          'secondaryButtonBorderBackgrounColor': null,
          'disableButtonBackgrounColor': null,
          'disableButtonTitleBackgrounColor': null,
          'checkboxColor': null,
        },
      });
    });
  });

  group('ParserYunoConfig', () {
    test('should correctly convert YunoConfig to map', () {
      const yunoConfig = YunoConfig(
        lang: YunoLanguage.en,
        cardFlow: CardFlow.oneStep,
        saveCardEnable: true,
        keepLoader: false,
        isDynamicViewEnable: true,
        cardFormDeployed: false,
      );

      final result = yunoConfig.toMap();

      expect(result, {
        'lang': YunoLanguage.en.rawValue,
        'cardFlow': 'oneStep',
        'saveCardEnable': true,
        'keepLoader': false,
        'isDynamicViewEnable': true,
        'cardFormDeployed': false,
      });
    });
  });

  group('ParserAppearance', () {
    test('should correctly convert Appearance to map with all nulls', () {
      const appearance = Appearance();

      final result = appearance.toMap();

      expect(result, {
        'fontFamily': null,
        'accentColor': null,
        'buttonBackgrounColor': null,
        'buttonTitleBackgrounColor': null,
        'buttonBorderBackgrounColor': null,
        'secondaryButtonBackgrounColor': null,
        'secondaryButtonTitleBackgrounColor': null,
        'secondaryButtonBorderBackgrounColor': null,
        'disableButtonBackgrounColor': null,
        'disableButtonTitleBackgrounColor': null,
        'checkboxColor': null,
      });
    });

    test('should correctly convert Appearance with values to map', () {
      const appearance = Appearance(
        fontFamily: 'Arial',
        accentColor: Color(0xFF0000FF),
        buttonBackgrounColor: Color(0xFF00FF00),
      );

      final result = appearance.toMap();

      expect(result, {
        'fontFamily': 'Arial',
        'accentColor': 0xFF0000FF,
        'buttonBackgrounColor': 0xFF00FF00,
        'buttonTitleBackgrounColor': null,
        'buttonBorderBackgrounColor': null,
        'secondaryButtonBackgrounColor': null,
        'secondaryButtonTitleBackgrounColor': null,
        'secondaryButtonBorderBackgrounColor': null,
        'disableButtonBackgrounColor': null,
        'disableButtonTitleBackgrounColor': null,
        'checkboxColor': null,
      });
    });
  });

  group('Parser', () {
    test('should correctly convert configuration to map', () {
      const yunoConfig = YunoConfig(
        lang: YunoLanguage.en,
        cardFlow: CardFlow.oneStep,
        saveCardEnable: true,
        keepLoader: true,
        isDynamicViewEnable: false,
        cardFormDeployed: true,
      );

      final configuration = {
        'key1': 'value1',
        'key2': 'value2',
      };

      final result = Parser.toMap(
        apiKey: 'testApiKey',
        countryCode: 'US',
        yunoConfig: yunoConfig,
        configuration: configuration,
      );

      expect(result, {
        'apiKey': 'testApiKey',
        'countryCode': 'US',
        'yunoConfig': {
          'lang': YunoLanguage.en.rawValue,
          'cardFlow': 'oneStep',
          'saveCardEnable': true,
          'keepLoader': true,
          'isDynamicViewEnable': false,
          'cardFormDeployed': true,
        },
        'configuration': {
          'key1': 'value1',
          'key2': 'value2',
        },
      });
    });

    test('should correctly convert configuration with null to map', () {
      const yunoConfig = YunoConfig(
        lang: YunoLanguage.es,
        cardFlow: CardFlow.multiStep,
        saveCardEnable: false,
        keepLoader: false,
        isDynamicViewEnable: true,
        cardFormDeployed: false,
      );

      final result = Parser.toMap(
        apiKey: 'testApiKey',
        countryCode: 'ES',
        yunoConfig: yunoConfig,
        configuration: null,
      );

      expect(result, {
        'apiKey': 'testApiKey',
        'countryCode': 'ES',
        'yunoConfig': {
          'lang': YunoLanguage.es.rawValue,
          'cardFlow': 'multiStep',
          'saveCardEnable': false,
          'keepLoader': false,
          'isDynamicViewEnable': true,
          'cardFormDeployed': false,
        },
        'configuration': null,
      });
    });
  });
}
