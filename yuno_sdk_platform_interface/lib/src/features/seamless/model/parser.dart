import 'package:yuno_sdk_platform_interface/yuno_sdk_platform_interface.dart';

extension SeamlessParser on SeamlessArguments {
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'language': language?.name,
      'countryCode': countryCode,
      'showPaymentStatus': showPaymentStatus,
      'checkoutSession': checkoutSession,
      'paymentMethodSelected': methodSelected.toMap(),
    };
  }
}
