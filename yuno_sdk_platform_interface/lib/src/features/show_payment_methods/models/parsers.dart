import 'package:yuno_sdk_platform_interface/src/features/show_payment_methods/models/payment_method_config.dart';

extension PaymentMethodsParser on PaymentMethodConf {
  Map<String, dynamic> toMap({
    required double currentWidth,
  }) {
    return <String, dynamic>{
      'checkoutSession': checkoutSession,
      'width': currentWidth,
      'viewType': iosViewType.index
    };
  }
}
