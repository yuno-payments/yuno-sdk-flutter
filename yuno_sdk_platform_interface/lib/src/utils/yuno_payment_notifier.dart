import 'package:flutter/widgets.dart';
import 'package:yuno_sdk_core/lib.dart';

class YunoPaymentState {
  const YunoPaymentState({
    required this.token,
    this.paymentStatus,
  });

  factory YunoPaymentState._empty() => const YunoPaymentState(
        token: '',
        paymentStatus: null,
      );

  final String token;
  final YunoStatus? paymentStatus;
}

final class YunoPaymentNotifier extends ValueNotifier<YunoPaymentState> {
  YunoPaymentNotifier() : super(YunoPaymentState._empty());

  void add(String token) {
    value = YunoPaymentState(
      token: token,
      paymentStatus: value.paymentStatus,
    );
  }

  void addStatus(YunoStatus status) {
    value = YunoPaymentState(
      token: value.token,
      paymentStatus: status,
    );
  }
}
