class PaymentMethodsArgs {
  const PaymentMethodsArgs({
    required this.checkoutSession,
  });
  final String checkoutSession;

  @override
  bool operator ==(covariant PaymentMethodsArgs other) {
    if (identical(this, other)) return true;

    return other.checkoutSession == checkoutSession;
  }

  @override
  int get hashCode => checkoutSession.hashCode;
}
