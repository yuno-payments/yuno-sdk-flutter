import 'package:yuno_sdk_core/lib.dart';
import 'package:yuno_sdk_platform_interface/yuno_sdk_platform_interface.dart';

class SeamlessArguments {
  SeamlessArguments({
    required this.checkoutSession,
    required this.methodSelected,
    this.countryCode,
    this.language,
    this.showPaymentStatus = true,
  });

  String? countryCode;
  YunoLanguage? language;
  final bool showPaymentStatus;
  final MethodSelected methodSelected;
  final String checkoutSession;
}
