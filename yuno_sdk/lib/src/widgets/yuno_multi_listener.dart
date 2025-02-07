import 'package:flutter/material.dart';
import 'package:yuno/src/internals.dart';
import 'package:yuno/yuno.dart';

/// {@template yuno_listener_YunoMultiListener}
/// A widget that listens for a multiple states change and provides a child widget.
///
/// The `YunoMultiListener` widget is a `StatefulWidget` that takes a child widget
/// and a callback functions `enrollmentListener` and `paymentListener` as required parameters. The widget
/// itself does not perform any actions but can be extended or used as a
/// placeholder where a token listening mechanism is needed.
///
/// This widget can be useful in scenarios where you need to trigger certain
/// actions or updates in the UI when a specific state changes.
///
/// ```dart
/// YunoMultiListener(
///   enrollmentListener: (state) {
///     // Handle [state] it is YunoEnrollmentState
///     // - [enrollmentStatus]: [reject,succeeded,fail,processing,internalError,cancelByUser]
///   },
///   paymentListener: (state) {
///     // Handle [state] it is YunoPaymentState [String token] && [PaymentStatus status]
///     // - [token]: One Time Token
///     // - [paymentStatus]: [reject,succeeded,fail,processing,internalError,cancelByUser]
///   }
///   child: SomeWidget(),
/// )
/// ```
///
/// The `YunoMultiListener` widget essentially wraps its `child` and can be
/// extended to include additional logic for token handling in the future.
///
/// - [child]: The widget that will be rendered as a descendant of
///   `YunoEnrollmentListener`.
/// - [enrollmentListener]: The callback function that listens to [enrollment] state changes.
/// - [paymentListener]: The callback function that listens to [payment] state changes.
/// {@endtemplate}
class YunoMultiListener extends StatefulWidget {
  /// Creates a `YunoMultiListener` widget.
  ///
  /// The [child] and [listenToken] parameters are required.
  /// {@macro yuno_listener_YunoMultiListener}
  const YunoMultiListener({
    super.key,
    required this.enrollmentListener,
    required this.paymentListener,
    required this.child,
  });

  /// The widget that will be displayed as the child of this `YunoMultiListener`.
  final Widget child;

  /// The callback function that listens for enrollment state changes.
  final YunoEnrollmentWidgetListener enrollmentListener;

  /// The callback function that listens for payment state changes.
  final YunoPaymentWidgetListener paymentListener;

  @override
  State<YunoMultiListener> createState() => _YunoPaymentListenerState();
}

class _YunoPaymentListenerState extends State<YunoMultiListener> {
  @override
  void initState() {
    super.initState();
    _enrollmentController.addListener(_enrollmentListener);
    _paymentController.addListener(_paymentListener);
  }

  void _enrollmentListener() {
    widget.enrollmentListener(context, _enrollmentController.value);
  }

  void _paymentListener() {
    widget.paymentListener(context, _paymentController.value);
  }

  @override
  Widget build(BuildContext context) {
    // Currently, this widget just returns the child.
    // You can add token listening logic here if needed.
    return widget.child;
  }

  @override
  void dispose() {
    _enrollmentController.removeListener(_enrollmentListener);
    _paymentController.removeListener(_paymentListener);
    super.dispose();
  }

  /// The controller managing the enrollment method state.
  ///
  /// This controller handles updates to the payment method display,
  /// including changes in size and content.
  YunoEnrollmentNotifier get _enrollmentController =>
      YunoPlatform.instance.enrollmentController;

  /// The controller managing the payment method state.
  ///
  /// This controller handles updates to the payment method display,
  /// including changes in size and content.
  YunoPaymentNotifier get _paymentController =>
      YunoPlatform.instance.controller;
}
