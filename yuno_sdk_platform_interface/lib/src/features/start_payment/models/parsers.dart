import 'package:yuno_sdk_platform_interface/yuno_sdk_platform_interface.dart';

extension ParserStartPayment on StartPayment {
  static Map<String, dynamic> toMap({
    required bool showPaymentStatus,
  }) {
    return <String, dynamic>{
      'showPaymentStatus': showPaymentStatus,
    };
  }
}
