import '../../../../core/commons.dart';
import '../../../src.dart';

extension SeamlessParser on SeamlessArguments {
  Map<String, dynamic> toMap({required YunoLanguage language}) {
    return <String, dynamic>{
      'language': language.name,
      'countryCode': countryCode,
      'showPaymentStatus': showPaymentStatus,
      'checkoutSession': checkoutSession,
      'paymentMethodSelected': methodSelected.toMap(),
    };
  }
}
