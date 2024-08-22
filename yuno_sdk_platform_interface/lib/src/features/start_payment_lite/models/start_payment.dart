import 'package:yuno_sdk_platform_interface/src/features/start_payment_lite/models/payment_method.dart';

class StartPayment {
  const StartPayment({
    this.showPaymentStatus = true,
    required this.paymentMethod,
  });

  final bool showPaymentStatus;
  final PaymentMethodSelected paymentMethod;

  @override
  bool operator ==(covariant StartPayment other) {
    if (identical(this, other)) return true;

    return other.showPaymentStatus == showPaymentStatus &&
        other.paymentMethod == paymentMethod;
  }

  @override
  int get hashCode => showPaymentStatus.hashCode ^ paymentMethod.hashCode;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'showPaymentStatus': showPaymentStatus,
      'paymentMethod': paymentMethod.toMap(),
    };
  }

  @override
  String toString() =>
      'StartPayment(showPaymentStatus: $showPaymentStatus, paymentMethod: $paymentMethod)';
}
