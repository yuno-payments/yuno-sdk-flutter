import 'package:flutter/widgets.dart';
import 'package:yuno_sdk_core/lib.dart';

class YunoState {
  const YunoState({
    required this.token,
    this.paymentStatus,
    this.enrollmentStatus,
  });

  factory YunoState._empty() => const YunoState(
        token: '',
        paymentStatus: null,
        enrollmentStatus: null,
      );

  final String token;
  final YunoStatus? paymentStatus;
  final YunoStatus? enrollmentStatus;
}

final class YunoNotifier extends ValueNotifier<YunoState> {
  YunoNotifier() : super(YunoState._empty());

  void add(String token) {
    value = YunoState(
      token: token,
      paymentStatus: value.paymentStatus,
      enrollmentStatus: value.enrollmentStatus,
    );
  }

  void addStatus(YunoStatus status) {
    value = YunoState(
      token: value.token,
      paymentStatus: status,
      enrollmentStatus: value.enrollmentStatus,
    );
  }

  void addEnrollmentStatus(YunoStatus status) {
    value = YunoState(
      token: value.token,
      enrollmentStatus: status,
      paymentStatus: value.paymentStatus,
    );
  }
}
