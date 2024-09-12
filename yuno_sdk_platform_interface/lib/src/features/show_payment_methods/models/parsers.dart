import 'package:yuno_sdk_platform_interface/src/features/show_payment_methods/models/payment_methods_args.dart';

extension PaymentMethodsParser on PaymentMethodsArgs {
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'checkoutSession': checkoutSession,
    };
  }
}
