import 'package:flutter/material.dart';
import 'package:yuno/src/internals.dart';

/// Signature for the `listener` function which takes the `BuildContext` along
/// with the `state` and is responsible for executing in response to
/// `state` changes.
typedef YunoPaymentWidgetListener = void Function(
    BuildContext context, YunoPaymentState state);

/// {@template yuno_listener_YunoPaymentListener}
/// A widget that listens for a payment state change and provides a child widget.
///
/// The `YunoPaymentListener`  is a Flutter Widget that takes a child widget
/// and a callback function `listener` as required parameters. The widget
/// itself does not perform any actions but can be extended or used as a
/// placeholder where a state listening mechanism is needed.
///
/// This widget can be useful in scenarios where you need to trigger certain
/// actions or updates in the UI when a specific state changes.
///
/// ```dart
/// YunoPaymentListener(
///   listener: (state) {
///     // Handle [state] it is YunoState [String token] && [PaymentStatus status]
///     // - [token]: One Time Token
///     // - [paymentStatus]: [reject,succeeded,fail,processing,internalError,cancelByUser]
///   },
///   child: SomeWidget(),
/// )
/// ```
///
/// The `YunoPaymentListener` widget essentially wraps its `child` and can be
/// extended to include additional logic for token handling in the future.
///
/// - [child]: The widget that will be rendered as a descendant of
///   `YunoPaymentListener`.
/// - [listener]: The callback function that listens to state changes.
/// {@endtemplate}
class YunoPaymentListener extends StatefulWidget {
  /// Creates a `YunoPaymentListener` widget.
  ///
  /// The [child] and [listenToken] parameters are required.
  /// {@macro yuno_listener_YunoPaymentListener}
  const YunoPaymentListener({
    super.key,
    required this.listener,
    required this.child,
  });

  /// The widget that will be displayed as the child of this `YunoPaymentListener`.
  final Widget child;

  /// The callback function that listens for token changes.
  final YunoPaymentWidgetListener listener;

  @override
  State<YunoPaymentListener> createState() => _YunoPaymentListenerState();
}

class _YunoPaymentListenerState extends State<YunoPaymentListener> {
  @override
  void initState() {
    super.initState();
    _controller.addListener(_listener);
  }

  void _listener() {
    widget.listener(context, _controller.value);
  }

  @override
  Widget build(BuildContext context) {
    // Currently, this widget just returns the child.
    // You can add token listening logic here if needed.
    return widget.child;
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    super.dispose();
  }

  YunoPaymentNotifier get _controller => YunoPlatform.instance.controller;
}
