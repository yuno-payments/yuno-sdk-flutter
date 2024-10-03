// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:yuno_sdk_platform_interface/lib.dart';

class PaymentMethodConf {
  const PaymentMethodConf({
    this.iosViewType = IOSViewType.separated,
    required this.checkoutSession,
  });

  final String checkoutSession;
  final IOSViewType iosViewType;
  @override
  bool operator ==(covariant PaymentMethodConf other) {
    if (identical(this, other)) return true;

    return other.checkoutSession == checkoutSession &&
        other.iosViewType == iosViewType;
  }

  @override
  int get hashCode => checkoutSession.hashCode ^ iosViewType.hashCode;
}
