import '../../../../core/commons.dart';
import 'ios_config.dart';

class YunoConfig {
  const YunoConfig({
    this.lang = YunoLanguage.en,
    this.saveCardEnable = false,
    this.keepLoader = false,
    this.appearance,
  });

  final YunoLanguage lang;
  final bool saveCardEnable;
  final bool keepLoader;

  /// Cross-platform appearance customization.
  ///
  /// Sets font family, button colors, and other visual properties
  /// for both iOS and Android. Platform-specific configs
  /// (`IosConfig.appearance` / `AndroidConfig.appearance`) take
  /// priority over this when provided.
  final Appearance? appearance;

  @override
  bool operator ==(covariant YunoConfig other) {
    if (identical(this, other)) return true;

    return other.saveCardEnable == saveCardEnable &&
        other.keepLoader == keepLoader &&
        other.lang == lang &&
        other.appearance == appearance;
  }

  @override
  int get hashCode {
    return saveCardEnable.hashCode ^
        keepLoader.hashCode ^
        lang.hashCode ^
        appearance.hashCode;
  }
}
