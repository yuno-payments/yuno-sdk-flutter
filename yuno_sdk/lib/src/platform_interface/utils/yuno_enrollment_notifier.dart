import 'package:flutter/widgets.dart';
import '../../core/commons.dart';

class YunoEnrollmentState {
  const YunoEnrollmentState({
    this.enrollmentStatus,
    this.message,
    this.substatus,
  });

  factory YunoEnrollmentState._empty() => const YunoEnrollmentState(
        enrollmentStatus: null,
      );

  final YunoStatus? enrollmentStatus;

  /// Structured detail describing why the enrollment ended in [enrollmentStatus].
  ///
  /// Populated by native Android SDK `>= 2.22.0` and iOS SDK `>= 2.23.0`.
  /// `null` when the native layer did not provide a message.
  final YunoStatusMessage? message;

  /// Raw substatus string reported alongside [enrollmentStatus].
  ///
  /// iOS: `Yuno.Result.substatus`. On Android the enrollment callback does not
  /// expose a substate, so this is `null` there.
  final String? substatus;
}

class YunoEnrollmentNotifier extends ValueNotifier<YunoEnrollmentState> {
  YunoEnrollmentNotifier() : super(YunoEnrollmentState._empty());

  void addEnrollmentStatus(YunoStatus status,
      [YunoStatusMessage? message, String? substatus]) {
    value = YunoEnrollmentState(
      enrollmentStatus: status,
      message: message,
      substatus: substatus,
    );
  }
}
