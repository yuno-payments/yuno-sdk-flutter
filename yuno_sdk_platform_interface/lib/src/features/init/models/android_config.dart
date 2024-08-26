import 'package:yuno_sdk_platform_interface/lib.dart';

class AndroidConfig {
  const AndroidConfig({
    this.cardFlow = CARDFLOW.oneStep,
    this.saveCardEnable = false,
    this.keepLoader = false,
    this.isDynamicViewEnable = false,
    this.cardFormDeployed = false,
  });

  final CARDFLOW cardFlow;
  final bool saveCardEnable;
  final bool keepLoader;
  final bool isDynamicViewEnable;
  final bool cardFormDeployed;

  @override
  bool operator ==(covariant AndroidConfig other) {
    if (identical(this, other)) return true;

    return other.cardFlow == cardFlow &&
        other.saveCardEnable == saveCardEnable &&
        other.keepLoader == keepLoader &&
        other.isDynamicViewEnable == isDynamicViewEnable &&
        other.cardFormDeployed == cardFormDeployed;
  }

  @override
  int get hashCode {
    return cardFlow.hashCode ^
        saveCardEnable.hashCode ^
        keepLoader.hashCode ^
        isDynamicViewEnable.hashCode ^
        cardFormDeployed.hashCode;
  }
}
