import '../../../src.dart';

extension ParserStartPayment on StartPayment {
  static Map<String, dynamic> toMap({
    required bool showPaymentStatus,
  }) {
    return <String, dynamic>{
      'showPaymentStatus': showPaymentStatus,
    };
  }
}
