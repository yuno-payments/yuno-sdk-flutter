import 'package:yuno_sdk_platform_interface/lib.dart';

extension ParserAndroidConfig on AndroidConfig {
  Map<String, dynamic> toMap() {
    return {
      'cardFormDeployed': cardFormDeployed,
    };
  }
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
      'lang': lang.rawValue,
      'cardFlow': cardFlow.toJson(),
      'saveCardEnable': saveCardEnable,
      'keepLoader': keepLoader,
      'isDynamicViewEnable': isDynamicViewEnable,
    };
  }
}

extension ParserAppearance on Appearance {
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accentColor': accentColor?.value,
      'buttonBackgrounColor': buttonBackgrounColor?.value,
      'buttonTitleBackgrounColor': buttonTitleBackgrounColor?.value,
      'buttonBorderBackgrounColor': buttonBorderBackgrounColor?.value,
      'secondaryButtonBackgrounColor': secondaryButtonBackgrounColor?.value,
      'secondaryButtonTitleBackgrounColor':
          secondaryButtonTitleBackgrounColor?.value,
      'secondaryButtonBorderBackgrounColor':
          secondaryButtonBorderBackgrounColor?.value,
      'disableButtonBackgrounColor': disableButtonBackgrounColor?.value,
      'disableButtonTitleBackgrounColor':
          disableButtonTitleBackgrounColor?.value,
      'checkboxColor': checkboxColor?.value,
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
