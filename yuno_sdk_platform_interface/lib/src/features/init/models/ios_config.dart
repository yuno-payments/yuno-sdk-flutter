// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/services.dart';

class IosConfig {
  const IosConfig({
    this.appearance,
  });

  final Appearance? appearance;

  @override
  bool operator ==(covariant IosConfig other) {
    if (identical(this, other)) return true;

    return other.appearance == appearance;
  }

  @override
  int get hashCode => appearance.hashCode;
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
