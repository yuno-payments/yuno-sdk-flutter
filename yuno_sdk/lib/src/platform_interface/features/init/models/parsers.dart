import 'package:flutter/material.dart';
import '../../../src.dart';

/// Helper function to convert Color to ARGB32 integer value
int _colorToInt(Color? color) {
  if (color == null) return null;
  return (color.alpha << 24) | (color.red << 16) | (color.green << 8) | color.blue;
}

extension ParserIosConfig on IosConfig {
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (appearance != null) {
      final appearanceMap = appearance!.toMap();
      if (appearanceMap.isNotEmpty) {
        map['appearance'] = appearanceMap;
      }
    }
    return map;
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
    final map = <String, dynamic>{};
    
    if (fontFamily != null) {
      map['fontFamily'] = fontFamily;
    }
    
    if (accentColor != null) {
      map['accentColor'] = _colorToInt(accentColor);
    }
    
    if (buttonBackgrounColor != null) {
      map['buttonBackgrounColor'] = _colorToInt(buttonBackgrounColor);
    }
    
    if (buttonTitleBackgrounColor != null) {
      map['buttonTitleBackgrounColor'] = _colorToInt(buttonTitleBackgrounColor);
    }
    
    if (buttonBorderBackgrounColor != null) {
      map['buttonBorderBackgrounColor'] = _colorToInt(buttonBorderBackgrounColor);
    }
    
    if (secondaryButtonBackgrounColor != null) {
      map['secondaryButtonBackgrounColor'] = _colorToInt(secondaryButtonBackgrounColor);
    }
    
    if (secondaryButtonTitleBackgrounColor != null) {
      map['secondaryButtonTitleBackgrounColor'] = _colorToInt(secondaryButtonTitleBackgrounColor);
    }
    
    if (secondaryButtonBorderBackgrounColor != null) {
      map['secondaryButtonBorderBackgrounColor'] = _colorToInt(secondaryButtonBorderBackgrounColor);
    }
    
    if (disableButtonBackgrounColor != null) {
      map['disableButtonBackgrounColor'] = _colorToInt(disableButtonBackgrounColor);
    }
    
    if (disableButtonTitleBackgrounColor != null) {
      map['disableButtonTitleBackgrounColor'] = _colorToInt(disableButtonTitleBackgrounColor);
    }
    
    if (checkboxColor != null) {
      map['checkboxColor'] = _colorToInt(checkboxColor);
    }
    
    return map;
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
