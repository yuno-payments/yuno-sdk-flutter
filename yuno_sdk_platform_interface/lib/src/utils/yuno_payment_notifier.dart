import 'dart:io';
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

final class YunoPaymentNotifier extends ValueNotifier<YunoPaymentMethodState> {
  YunoPaymentNotifier() : super(YunoPaymentMethodState._empty());

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

  void _safeUpdate(VoidCallback update) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        update();
      },
    );
  }
}
