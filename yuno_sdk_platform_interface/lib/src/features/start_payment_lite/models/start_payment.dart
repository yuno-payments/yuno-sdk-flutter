import 'package:yuno_sdk_platform_interface/src/features/start_payment_lite/models/payment_method.dart';

class StartPayment {
  const StartPayment({
    this.showPaymentStatus = true,
    required this.checkoutSession,
    required this.methodSelected,
  });

  final bool showPaymentStatus;
  final MethodSelected methodSelected;
  final String checkoutSession;

  @override
  bool operator ==(covariant StartPayment other) {
    if (identical(this, other)) return true;

    return other.showPaymentStatus == showPaymentStatus &&
        other.methodSelected == methodSelected;
  }

  @override
  int get hashCode => showPaymentStatus.hashCode ^ methodSelected.hashCode;

  Map<String, dynamic> toMap({required String countryCode}) {
    return <String, dynamic>{
      'countryCode': countryCode,
      'showPaymentStatus': showPaymentStatus,
      'checkoutSession': checkoutSession,
      'paymentMetdhodSelected': methodSelected.toMap(),
    };
  }

  @override
  String toString() =>
      'StartPayment(showPaymentStatus: $showPaymentStatus, paymentMethod: $methodSelected)';
}
