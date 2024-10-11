class StartPaymentModel {
  final String checkoutSession;
  final bool showPaymentStatus;

  const StartPaymentModel({
    required this.checkoutSession,
    required this.showPaymentStatus,
  });
}
