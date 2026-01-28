import 'package:flutter/material.dart';
import 'package:yuno_sdk_platform_interface/yuno_sdk_platform_interface.dart';

/// Helper function to convert Color to ARGB32 integer value
int _colorToInt(Color? color) {
  if (color == null) return 0;
  return (color.alpha << 24) | (color.red << 16) | (color.green << 8) | color.blue;
}

extension ParserIosConfig on IosConfig {
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'appearance': appearance?.toMap(),
    };
  }
}

extension ParserYunoConfig on YunoConfig {
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lang': lang.rawValue.toLowerCase(),
      'cardFlow': cardFlow.name,
      'saveCardEnable': saveCardEnable,
      'keepLoader': keepLoader,
      'isDynamicViewEnable': isDynamicViewEnable,
      'cardFormDeployed': cardFormDeployed,
    };
  }
}

extension ParserAppearance on Appearance {
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fontFamily': fontFamily,
      'accentColor': _colorToInt(accentColor),
      'buttonBackgrounColor': _colorToInt(buttonBackgrounColor),
      'buttonTitleBackgrounColor': _colorToInt(buttonTitleBackgrounColor),
      'buttonBorderBackgrounColor': _colorToInt(buttonBorderBackgrounColor),
      'secondaryButtonBackgrounColor': _colorToInt(secondaryButtonBackgrounColor),
      'secondaryButtonTitleBackgrounColor':
          _colorToInt(secondaryButtonTitleBackgrounColor),
      'secondaryButtonBorderBackgrounColor':
          _colorToInt(secondaryButtonBorderBackgrounColor),
      'disableButtonBackgrounColor': _colorToInt(disableButtonBackgrounColor),
      'disableButtonTitleBackgrounColor':
          _colorToInt(disableButtonTitleBackgrounColor),
      'checkboxColor': _colorToInt(checkboxColor),
    };
  }
}

extension Parser on Never {
  static Map<String, dynamic> toMap({
    required String apiKey,
    required String countryCode,
    required YunoConfig yunoConfig,
    Map<String, dynamic>? configuration,
  }) {
    return <String, dynamic>{
      'apiKey': apiKey,
      'countryCode': countryCode,
      'yunoConfig': yunoConfig.toMap(),
      'configuration': configuration,
    };
  }
}
