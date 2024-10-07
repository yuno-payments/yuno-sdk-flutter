import 'package:yuno_sdk_platform_interface/lib.dart';

extension ParserStartPayment on StartPayment {
  static Map<String, dynamic> toMap({
    required String checkoutSession,
    required bool showPaymentStatus,
  }) {
    return <String, dynamic>{
      'checkoutSession': checkoutSession,
      'showPaymentStatus': showPaymentStatus,
    };
  }
}
