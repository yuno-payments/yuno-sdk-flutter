import 'package:flutter/widgets.dart';

class YunoPaymentSelectState {
  const YunoPaymentSelectState({
    required this.isSelected,
  });

  factory YunoPaymentSelectState._empty() =>
      const YunoPaymentSelectState(isSelected: false);

  YunoPaymentSelectState copyWith(
      {double? height, double? width, bool? isSelected}) {
    return YunoPaymentSelectState(
      isSelected: isSelected ?? this.isSelected,
    );
  }

  final bool isSelected;
}

class YunoPaymentSelectNotifier extends ValueNotifier<YunoPaymentSelectState> {
  YunoPaymentSelectNotifier() : super(YunoPaymentSelectState._empty());

  void isSelectedUpdate(bool isSelected) {
    value = value.copyWith(isSelected: isSelected);
  }
}
