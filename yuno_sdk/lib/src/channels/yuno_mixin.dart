import 'package:yuno/yuno.dart';

abstract mixin class YunoMixin {
  Future<void> openPaymentMethodsScreen();
  Future<void> startPaymentLite({
    required StartPayment arguments,
  });
}
