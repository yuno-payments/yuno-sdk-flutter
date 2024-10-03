import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:yuno/src/internals.dart';

/// Signature for the `listener` function which takes the `BuildContext` along
/// with the `isSelected` state and is responsible for executing in response to
/// state changes.
typedef YunoPaymentWidgetListener = void Function(
    BuildContext context, bool isSelected);

/// A widget that displays payment methods using a native iOS view.
///
/// This widget integrates with the Yuno SDK to show payment methods in a Flutter app.
/// It dynamically adjusts its size based on the content and available width.
///
/// The widget also provides a listener to notify about selection changes.
///
/// Usage:
/// ```dart
/// YunoPaymentMethods(
///   checkoutSession: 'your_checkout_session_id',
///   listener: (context, isSelected) {
///     // Handle selection change
///   },
/// )
/// ```
///
/// The widget listens to changes in the payment method state and rebuilds accordingly.
class YunoPaymentMethods extends StatefulWidget {
  /// Creates a YunoPaymentMethods widget.
  ///
  /// The [config] parameter is required and represents the unique
  /// identifier for the current checkout session.
  ///
  /// The [listener] parameter is required and will be called whenever the
  /// selection state changes.
  const YunoPaymentMethods({
    super.key,
    required this.config,
    required this.listener,
  });

  /// The [config] permit custom native configuration.
  final PaymentMethodConf config;

  /// A function that is called when the payment method selection changes.
  ///
  /// The function is passed the current [BuildContext] and a boolean indicating
  /// whether a payment method is selected.
  final YunoPaymentWidgetListener listener;

  @override
  State<YunoPaymentMethods> createState() => _YunoPaymentMethodsState();
}

class _YunoPaymentMethodsState extends State<YunoPaymentMethods> {
  @override
  void initState() {
    super.initState();
    _selectController.addListener(_listener);
  }

  /// Listener method called when the payment method state changes.
  ///
  /// This method invokes the [YunoPaymentWidgetListener] provided in the widget
  /// constructor, passing the current context and selection state.
  void _listener() {
    widget.listener(context, _selectController.value.isSelected);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<YunoPaymentMethodState>(
      valueListenable: _controller,
      builder: (context, value, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final double currentWidth = constraints.maxWidth;
            if (value.width != currentWidth) {
              _controller.updateLastWidth(currentWidth);
            }

            return ConstrainedBox(
              constraints: BoxConstraints.expand(height: value.height),
              child: UiKitView(
                key: ValueKey(currentWidth),
                onPlatformViewCreated: YunoPaymentMethodPlatform.init,
                viewType: YunoPaymentMethodPlatform.viewType,
                creationParamsCodec: const StandardMessageCodec(),
                creationParams: widget.config.toMap(
                  currentWidth: currentWidth,
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// The controller managing the payment method state.
  YunoPaymentNotifier get _controller => YunoPaymentMethodPlatform.controller;

  /// The controller managing the payment method selected.
  YunoPaymentSelectNotifier get _selectController =>
      YunoPaymentMethodPlatform.selectController;

  @override
  void dispose() {
    _selectController.removeListener(_listener);
    super.dispose();
  }
}
