class PaymentMethodConf {
  const PaymentMethodConf({
    required this.checkoutSession,
    this.countryCode,
  });

  final String checkoutSession;
  final String? countryCode;

  @override
  bool operator ==(covariant PaymentMethodConf other) {
    if (identical(this, other)) return true;

    return other.checkoutSession == checkoutSession &&
        other.countryCode == countryCode;
  }

  @override
  int get hashCode =>
      checkoutSession.hashCode ^ countryCode.hashCode;
}
