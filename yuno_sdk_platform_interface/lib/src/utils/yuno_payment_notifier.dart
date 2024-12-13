import 'package:flutter/widgets.dart';
import 'package:yuno_sdk_core/lib.dart';

class YunoPaymentState {
  const YunoPaymentState({
    this.token = '',
    this.paymentStatus,
  });

  factory YunoPaymentState._empty() => const YunoPaymentState(token: '');

  final String token;
  final YunoStatus? paymentStatus;
}

class YunoPaymentNotifier extends ValueNotifier<YunoPaymentState> {
  YunoPaymentNotifier() : super(YunoPaymentState._empty());

  void add(String token) {
    value = YunoPaymentState(
      token: token,
    );
  }

  void addStatus(YunoStatus status) {
    value = YunoPaymentState(
      token: '',
      paymentStatus: status,
    );
  }
}
