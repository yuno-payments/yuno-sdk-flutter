import 'package:yuno_sdk_platform_interface/yuno_sdk_platform_interface.dart';

class PaymentMethodConf {
  const PaymentMethodConf({
    this.iosViewType = IOSViewType.separated,
    required this.checkoutSession,
    this.countryCode,
  });

  final String checkoutSession;
  final String? countryCode;
  final IOSViewType iosViewType;

  @override
  bool operator ==(covariant PaymentMethodConf other) {
    if (identical(this, other)) return true;

    return other.checkoutSession == checkoutSession &&
        other.countryCode == countryCode &&
        other.iosViewType == iosViewType;
  }

  @override
  int get hashCode =>
      checkoutSession.hashCode ^ countryCode.hashCode ^ iosViewType.hashCode;
}
