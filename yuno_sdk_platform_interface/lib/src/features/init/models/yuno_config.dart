import 'package:yuno_sdk_core/lib.dart';
import 'package:yuno_sdk_platform_interface/lib.dart';

class YunoConfig {
  const YunoConfig({
    this.lang = YunoLanguage.en,
    this.cardflow = CARDFLOW.oneStep,
    this.saveCardEnable = false,
    this.keepLoader = false,
    this.isDynamicViewEnable = false,
  });

  final YunoLanguage lang;
  final CARDFLOW cardflow;
  final bool saveCardEnable;
  final bool keepLoader;
  final bool isDynamicViewEnable;

  @override
  bool operator ==(covariant YunoConfig other) {
    if (identical(this, other)) return true;

    return other.cardflow == cardflow &&
        other.saveCardEnable == saveCardEnable &&
        other.keepLoader == keepLoader &&
        other.isDynamicViewEnable == isDynamicViewEnable &&
        other.lang == lang;
  }

  @override
  int get hashCode {
    return cardflow.hashCode ^
        saveCardEnable.hashCode ^
        keepLoader.hashCode ^
        isDynamicViewEnable.hashCode ^
        lang.hashCode;
  }
}
