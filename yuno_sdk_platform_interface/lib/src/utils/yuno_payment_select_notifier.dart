import 'package:flutter/widgets.dart';
import 'package:yuno_sdk_platform_interface/yuno_sdk_platform_interface.dart';

class YunoPaymentSelectState {
  const YunoPaymentSelectState({
    required this.isSelected,
    this.methodSelected,
  });

  factory YunoPaymentSelectState._empty() =>
      const YunoPaymentSelectState(isSelected: false);

  YunoPaymentSelectState copyWith({
    double? height,
    double? width,
    bool? isSelected,
    MethodSelected? methodSelected,
  }) {
    return YunoPaymentSelectState(
      isSelected: isSelected ?? this.isSelected,
      methodSelected: methodSelected ?? this.methodSelected,
    );
  }

  final bool isSelected;
  final MethodSelected? methodSelected;
}

class YunoPaymentSelectNotifier extends ValueNotifier<YunoPaymentSelectState> {
  YunoPaymentSelectNotifier() : super(YunoPaymentSelectState._empty());

  void isSelectedUpdate(bool isSelected) {
    value = value.copyWith(isSelected: isSelected);
  }

  void methodSelectedUpdate(MethodSelected? methodSelected) {
    value = value.copyWith(
      isSelected: methodSelected != null,
      methodSelected: methodSelected,
    );
  }
}
