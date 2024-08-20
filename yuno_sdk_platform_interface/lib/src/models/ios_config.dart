import 'package:flutter/services.dart';
import 'package:yuno_sdk_platform_interface/lib.dart';

class IosConfig {
  const IosConfig({
    this.cardflow = CARDFLOW.oneStep,
    this.saveCardEnable = false,
    this.keepLoader = false,
    this.isDynamicViewEnable = false,
    this.appearance,
  });

  final CARDFLOW cardflow;
  final Appearance? appearance;
  final bool saveCardEnable;
  final bool keepLoader;
  final bool isDynamicViewEnable;

  @override
  bool operator ==(covariant IosConfig other) {
    if (identical(this, other)) return true;

    return other.cardflow == cardflow &&
        other.saveCardEnable == saveCardEnable &&
        other.keepLoader == keepLoader &&
        other.isDynamicViewEnable == isDynamicViewEnable;
  }

  @override
  int get hashCode {
    return cardflow.hashCode ^
        saveCardEnable.hashCode ^
        keepLoader.hashCode ^
        isDynamicViewEnable.hashCode;
  }
}

class Appearance {
  const Appearance({
    this.accentColor,
    this.buttonBackgrounColor,
    this.buttonTitleBackgrounColor,
    this.buttonBorderBackgrounColor,
    this.secondaryButtonBackgrounColor,
    this.secondaryButtonTitleBackgrounColor,
    this.secondaryButtonBorderBackgrounColor,
    this.disableButtonBackgrounColor,
    this.disableButtonTitleBackgrounColor,
    this.checkboxColor,
  });

  final Color? accentColor;
  final Color? buttonBackgrounColor;
  final Color? buttonTitleBackgrounColor;
  final Color? buttonBorderBackgrounColor;
  final Color? secondaryButtonBackgrounColor;
  final Color? secondaryButtonTitleBackgrounColor;
  final Color? secondaryButtonBorderBackgrounColor;
  final Color? disableButtonBackgrounColor;
  final Color? disableButtonTitleBackgrounColor;
  final Color? checkboxColor;

  @override
  bool operator ==(covariant Appearance other) {
    if (identical(this, other)) return true;

    return other.accentColor == accentColor &&
        other.buttonBackgrounColor == buttonBackgrounColor &&
        other.buttonTitleBackgrounColor == buttonTitleBackgrounColor &&
        other.buttonBorderBackgrounColor == buttonBorderBackgrounColor &&
        other.secondaryButtonBackgrounColor == secondaryButtonBackgrounColor &&
        other.secondaryButtonTitleBackgrounColor ==
            secondaryButtonTitleBackgrounColor &&
        other.secondaryButtonBorderBackgrounColor ==
            secondaryButtonBorderBackgrounColor &&
        other.disableButtonBackgrounColor == disableButtonBackgrounColor &&
        other.disableButtonTitleBackgrounColor ==
            disableButtonTitleBackgrounColor &&
        other.checkboxColor == checkboxColor;
  }

  @override
  int get hashCode {
    return accentColor.hashCode ^
        buttonBackgrounColor.hashCode ^
        buttonTitleBackgrounColor.hashCode ^
        buttonBorderBackgrounColor.hashCode ^
        secondaryButtonBackgrounColor.hashCode ^
        secondaryButtonTitleBackgrounColor.hashCode ^
        secondaryButtonBorderBackgrounColor.hashCode ^
        disableButtonBackgrounColor.hashCode ^
        disableButtonTitleBackgrounColor.hashCode ^
        checkboxColor.hashCode;
  }
}
