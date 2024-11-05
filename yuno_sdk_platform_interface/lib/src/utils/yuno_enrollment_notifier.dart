import 'package:flutter/widgets.dart';
import 'package:yuno_sdk_core/lib.dart';

class YunoEnrollmentState {
  const YunoEnrollmentState({
    this.enrollmentStatus,
  });

  factory YunoEnrollmentState._empty() => const YunoEnrollmentState(
        enrollmentStatus: null,
      );

  final YunoStatus? enrollmentStatus;
}

final class YunoEnrollmentNotifier extends ValueNotifier<YunoEnrollmentState> {
  YunoEnrollmentNotifier() : super(YunoEnrollmentState._empty());

  void addEnrollmentStatus(YunoStatus status) {
    value = YunoEnrollmentState(
      enrollmentStatus: status,
    );
  }
}
