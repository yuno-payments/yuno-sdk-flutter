import 'package:flutter/widgets.dart';
import '../../core/commons.dart';

class YunoPaymentState {
  const YunoPaymentState({
    this.token = '',
    this.paymentStatus,
    this.message,
    this.substatus,
  });

  factory YunoPaymentState._empty() => const YunoPaymentState(token: '');

  final String token;
  final YunoStatus? paymentStatus;

  /// Structured detail describing why the payment ended in [paymentStatus].
  ///
  /// Populated by native Android SDK `>= 2.22.0` and iOS SDK `>= 2.23.0`.
  /// `null` when the native layer did not provide a message.
  final YunoStatusMessage? message;

  /// Raw substatus string reported alongside [paymentStatus].
  ///
  /// iOS: `Yuno.Result.substatus`. Android: the native `PaymentSubStates`
  /// value (e.g. `AUTHORIZED`, `CLOSED_BY_USER`, `WAITING_ADDITIONAL_STEP`).
  /// `null` when the native layer did not provide one.
  final String? substatus;
}

class YunoPaymentNotifier extends ValueNotifier<YunoPaymentState> {
  YunoPaymentNotifier() : super(YunoPaymentState._empty());

  void add(String token) {
    value = YunoPaymentState(
      token: token,
    );
  }

  void addStatus(YunoStatus status,
      [YunoStatusMessage? message, String? substatus]) {
    value = YunoPaymentState(
      token: '',
      paymentStatus: status,
      message: message,
      substatus: substatus,
    );
  }
}
