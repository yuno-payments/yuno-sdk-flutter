import 'package:yuno_sdk_core/lib.dart';
import 'package:yuno_sdk_platform_interface/lib.dart';

class YunoConfig {
  const YunoConfig({
    this.lang = YunoLanguage.en,
    this.cardFlow = CardFlow.oneStep,
    this.saveCardEnable = false,
    this.keepLoader = false,
    this.isDynamicViewEnable = false,
    this.cardFormDeployed = false,
  });

  final YunoLanguage lang;
  final CardFlow cardFlow;
  final bool saveCardEnable;
  final bool keepLoader;
  final bool isDynamicViewEnable;
  final bool cardFormDeployed;

  @override
  bool operator ==(covariant YunoConfig other) {
    if (identical(this, other)) return true;

    return other.cardFlow == cardFlow &&
        other.saveCardEnable == saveCardEnable &&
        other.keepLoader == keepLoader &&
        other.isDynamicViewEnable == isDynamicViewEnable &&
        other.lang == lang;
  }

  @override
  int get hashCode {
    return cardFlow.hashCode ^
        saveCardEnable.hashCode ^
        keepLoader.hashCode ^
        isDynamicViewEnable.hashCode ^
        lang.hashCode;
  }
}
