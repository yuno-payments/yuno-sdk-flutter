import 'package:yuno_sdk_platform_interface/yuno_sdk_platform_interface.dart';

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
      'accentColor': accentColor?.toARGB32(),
      'buttonBackgrounColor': buttonBackgrounColor?.toARGB32(),
      'buttonTitleBackgrounColor': buttonTitleBackgrounColor?.toARGB32(),
      'buttonBorderBackgrounColor': buttonBorderBackgrounColor?.toARGB32(),
      'secondaryButtonBackgrounColor': secondaryButtonBackgrounColor?.toARGB32(),
      'secondaryButtonTitleBackgrounColor':
          secondaryButtonTitleBackgrounColor?.toARGB32(),
      'secondaryButtonBorderBackgrounColor':
          secondaryButtonBorderBackgrounColor?.toARGB32(),
      'disableButtonBackgrounColor': disableButtonBackgrounColor?.toARGB32(),
      'disableButtonTitleBackgrounColor':
          disableButtonTitleBackgrounColor?.toARGB32(),
      'checkboxColor': checkboxColor?.toARGB32(),
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
