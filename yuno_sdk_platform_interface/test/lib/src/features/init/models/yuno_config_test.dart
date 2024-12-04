import 'package:flutter_test/flutter_test.dart';
import 'package:yuno_sdk_core/lib.dart';
import 'package:yuno_sdk_platform_interface/src/src.dart';

void main() {
  group('YunoConfig', () {
    test('should correctly initialize properties with default values', () {
      const config = YunoConfig();

      expect(config.lang, YunoLanguage.en);
      expect(config.cardFlow, CardFlow.oneStep);
      expect(config.saveCardEnable, false);
      expect(config.keepLoader, false);
      expect(config.isDynamicViewEnable, false);
      expect(config.cardFormDeployed, false);
    });

    test('should correctly initialize properties with custom values', () {
      const config = YunoConfig(
        lang: YunoLanguage.es,
        cardFlow: CardFlow.multiStep,
        saveCardEnable: true,
        keepLoader: true,
        isDynamicViewEnable: true,
        cardFormDeployed: true,
      );

      expect(config.lang, YunoLanguage.es);
      expect(config.cardFlow, CardFlow.multiStep);
      expect(config.saveCardEnable, true);
      expect(config.keepLoader, true);
      expect(config.isDynamicViewEnable, true);
      expect(config.cardFormDeployed, true);
    });

    // Focused tests for each field in equality operator
    test('should correctly compare lang property', () {
      const config1 = YunoConfig(lang: YunoLanguage.en);
      const config2 = YunoConfig(lang: YunoLanguage.en);
      const config3 = YunoConfig(lang: YunoLanguage.es);

      expect(config1 == config2, true); // Same lang
      expect(config1 == config3, false); // Different lang
    });

    test('should correctly compare cardFlow property', () {
      const config1 = YunoConfig(cardFlow: CardFlow.oneStep);
      const config2 = YunoConfig(cardFlow: CardFlow.oneStep);
      const config3 = YunoConfig(cardFlow: CardFlow.multiStep);

      expect(config1 == config2, true); // Same cardFlow
      expect(config1 == config3, false); // Different cardFlow
    });

    test('should correctly compare saveCardEnable property', () {
      const config1 = YunoConfig(saveCardEnable: false);
      const config2 = YunoConfig(saveCardEnable: false);
      const config3 = YunoConfig(saveCardEnable: true);

      expect(config1 == config2, true); // Same saveCardEnable
      expect(config1 == config3, false); // Different saveCardEnable
    });

    test('should correctly compare keepLoader property', () {
      const config1 = YunoConfig(keepLoader: false);
      const config2 = YunoConfig(keepLoader: false);
      const config3 = YunoConfig(keepLoader: true);

      expect(config1 == config2, true); // Same keepLoader
      expect(config1 == config3, false); // Different keepLoader
    });

    test('should correctly compare isDynamicViewEnable property', () {
      const config1 = YunoConfig(isDynamicViewEnable: false);
      const config2 = YunoConfig(isDynamicViewEnable: false);
      const config3 = YunoConfig(isDynamicViewEnable: true);

      expect(config1 == config2, true); // Same isDynamicViewEnable
      expect(config1 == config3, false); // Different isDynamicViewEnable
    });

    test('should generate consistent hashCode for identical values', () {
      const config1 = YunoConfig(
        lang: YunoLanguage.en,
        cardFlow: CardFlow.oneStep,
        saveCardEnable: false,
        keepLoader: false,
        isDynamicViewEnable: false,
      );

      const config2 = YunoConfig(
        lang: YunoLanguage.en,
        cardFlow: CardFlow.oneStep,
        saveCardEnable: false,
        keepLoader: false,
        isDynamicViewEnable: false,
      );

      expect(config1.hashCode, config2.hashCode); // Equal hashCode
    });

    test('should generate different hashCodes for different values', () {
      const config1 = YunoConfig(
        lang: YunoLanguage.en,
        cardFlow: CardFlow.oneStep,
        saveCardEnable: false,
        keepLoader: false,
        isDynamicViewEnable: false,
      );

      const config2 = YunoConfig(
        lang: YunoLanguage.es, // Different lang
        cardFlow: CardFlow.multiStep, // Different cardFlow
        saveCardEnable: true, // Different saveCardEnable
        keepLoader: true, // Different keepLoader
        isDynamicViewEnable: true, // Different isDynamicViewEnable
      );

      expect(config1.hashCode, isNot(config2.hashCode)); // Different hashCode
    });
  });
}
