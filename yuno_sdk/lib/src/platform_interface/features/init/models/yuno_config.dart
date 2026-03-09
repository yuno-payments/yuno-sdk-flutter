import '../../../../core/commons.dart';

class YunoConfig {
  const YunoConfig({
    this.lang = YunoLanguage.en,
    this.saveCardEnable = false,
    this.keepLoader = false,
  });

  final YunoLanguage lang;
  final bool saveCardEnable;
  final bool keepLoader;

  @override
  bool operator ==(covariant YunoConfig other) {
    if (identical(this, other)) return true;

    return other.saveCardEnable == saveCardEnable &&
        other.keepLoader == keepLoader &&
        other.lang == lang;
  }

  @override
  int get hashCode {
    return saveCardEnable.hashCode ^
        keepLoader.hashCode ^
        lang.hashCode;
  }
}
