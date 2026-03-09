import '../../../src.dart';

class SeamlessArguments {
  SeamlessArguments({
    required this.checkoutSession,
    required this.methodSelected,
    this.countryCode,
    this.showPaymentStatus = true,
  });

  String? countryCode;
  final bool showPaymentStatus;
  final MethodSelected methodSelected;
  final String checkoutSession;
}
