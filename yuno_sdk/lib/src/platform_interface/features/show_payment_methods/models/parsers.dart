import '../models/payment_method_config.dart';
import '../../../utils/utils.dart';

extension PaymentMethodsParser on PaymentMethodConf {
  Map<String, dynamic> toMap({
    required double currentWidth,
    bool isRTL = false,
  }) {
    return <String, dynamic>{
      'checkoutSession': checkoutSession,
      'countryCode': countryCode ??
          YunoSharedSingleton.getValue(KeysSingleton.countryCode.name),
      'width': currentWidth,
      'isRTL': isRTL,
    };
  }
}
