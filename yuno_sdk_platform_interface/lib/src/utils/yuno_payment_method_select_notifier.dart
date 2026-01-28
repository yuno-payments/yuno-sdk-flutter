import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class YunoPaymentMethodState {
  const YunoPaymentMethodState({
    required this.height,
    required this.width,
  });
  factory YunoPaymentMethodState._empty() => YunoPaymentMethodState(
        height: Platform.isIOS ? 0.0 : 15.0,
        width: 0.0,
      );

  YunoPaymentMethodState copyWith(
      {double? height, double? width, bool? isSelected}) {
    return YunoPaymentMethodState(
      height: height ?? this.height,
      width: width ?? this.width,
    );
  }

  final double height;
  final double width;

  @override
  bool operator ==(covariant YunoPaymentMethodState other) {
    if (identical(this, other)) return true;
    return other.height == height && other.width == width;
  }

  @override
  int get hashCode => height.hashCode ^ width.hashCode;
}

class YunoPaymentMethodSelectNotifier
    extends ValueNotifier<YunoPaymentMethodState> {
  YunoPaymentMethodSelectNotifier() : super(YunoPaymentMethodState._empty());

  void updateHeight(double height) {
    _safeUpdate(() {
      value = value.copyWith(height: height);
    });
  }

  void updateLastWidth(double width) {
    _safeUpdate(() {
      value = value.copyWith(width: width);
    });
  }

  /// Resets the height to the initial platform-specific value.
  ///
  /// This is useful when creating a new widget instance to ensure
  /// it starts with the correct initial height instead of keeping
  /// the previous value from a previous widget instance.
  ///
  /// This method updates the value synchronously to ensure the reset
  /// happens immediately, unlike updateHeight() which uses postFrameCallback.
  void resetHeight() {
    final initialHeight = Platform.isIOS ? 0.0 : 15.0;
    // Update synchronously instead of using _safeUpdate to ensure immediate reset
    value = value.copyWith(height: initialHeight);
  }

  void _safeUpdate(VoidCallback update) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        update();
      },
    );
  }
}
