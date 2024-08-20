import 'package:yuno_sdk_platform_interface/lib.dart';

class AndroidConfig {
  const AndroidConfig({
     this.cardflow = CARDFLOW.oneStep,
    this.saveCardEnable = false,
    this.keepLoader =false,
    this.isDynamicViewEnable = false,
    this.cardFormDeployed= false,
  });

  final CARDFLOW cardflow;
  final bool saveCardEnable;
  final bool keepLoader;
  final bool isDynamicViewEnable;
  final bool cardFormDeployed;


  @override
  bool operator ==(covariant AndroidConfig other) {
    if (identical(this, other)) return true;
  
    return 
      other.cardflow == cardflow &&
      other.saveCardEnable == saveCardEnable &&
      other.keepLoader == keepLoader &&
      other.isDynamicViewEnable == isDynamicViewEnable &&
      other.cardFormDeployed == cardFormDeployed;
  }

  @override
  int get hashCode {
    return cardflow.hashCode ^
      saveCardEnable.hashCode ^
      keepLoader.hashCode ^
      isDynamicViewEnable.hashCode ^
      cardFormDeployed.hashCode;
  }
}
