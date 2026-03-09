import 'package:flutter/widgets.dart';
import '../../core/commons.dart';

class YunoEnrollmentState {
  const YunoEnrollmentState({
    this.enrollmentStatus,
  });

  factory YunoEnrollmentState._empty() => const YunoEnrollmentState(
        enrollmentStatus: null,
      );

  final YunoStatus? enrollmentStatus;
}

class YunoEnrollmentNotifier extends ValueNotifier<YunoEnrollmentState> {
  YunoEnrollmentNotifier() : super(YunoEnrollmentState._empty());

  void addEnrollmentStatus(YunoStatus status) {
    value = YunoEnrollmentState(
      enrollmentStatus: status,
    );
  }
}
