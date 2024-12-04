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

    test('should support equality operator', () {
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

      const config3 = YunoConfig(
        lang: YunoLanguage.es,
        cardFlow: CardFlow.multiStep,
        saveCardEnable: true,
      );

      expect(config1 == config2, true); // Equal
      expect(config1 == config3, false); // Not equal
    });

    test('should generate consistent hashCode', () {
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
  });
}
