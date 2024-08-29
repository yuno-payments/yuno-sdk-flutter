import 'package:flutter/widgets.dart';
import 'package:yuno_sdk_core/lib.dart';

class YunoState {
  const YunoState({required this.token, this.status});

  factory YunoState.empty() => const YunoState(token: '', status: null);

  final String token;
  final PaymentStatus? status;
}

final class YunoNotifier extends ValueNotifier<YunoState> {
  YunoNotifier() : super(YunoState.empty());

  void add(String token) {
    value = YunoState(token: token);
  }

  void addStatus(PaymentStatus status) {
    value = YunoState(token: value.token, status: status);
  }
}
