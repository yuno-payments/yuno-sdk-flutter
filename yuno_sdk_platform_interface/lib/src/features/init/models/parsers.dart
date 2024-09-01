import 'package:yuno_sdk_core/commons/src/enums/yuno_language.dart';
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
    required CARDFLOW cardflow,
    required bool saveCardEnable,
    required bool keepLoader,
    required bool isDynamicViewEnable,
    required YunoLanguage lang,
    Map<String, dynamic>? configuration,
  }) {
    return <String, dynamic>{
      'apiKey': apiKey,
      'lang': lang.rawValue,
      'countryCode': countryCode,
      'cardFlow': cardflow.toJson(),
      'saveCardEnable': saveCardEnable,
      'keepLoader': keepLoader,
      'isDynamicViewEnable': isDynamicViewEnable,
      'configuration': configuration,
    };
  }
}
