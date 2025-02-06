import 'package:flutter/material.dart';
import 'package:yuno/src/internals.dart';

/// Signature for the `listener` function which takes the `BuildContext` along
/// with the `state` and is responsible for executing in response to
/// `state` changes.
typedef YunoEnrollmentWidgetListener = void Function(
    BuildContext context, YunoEnrollmentState state);

/// {@template yuno_listener_YunoEnrollmentListener}
/// A widget that listens for a token change and provides a child widget.
///
/// The `YunoEnrollmentListener` is a Flutter Widget that takes a child widget
/// and a callback function `listener` as required parameters. The widget
/// itself does not perform any actions but can be extended or used as a
/// placeholder where a token listening mechanism is needed.
///
/// This widget can be useful in scenarios where you need to trigger certain
/// actions or updates in the UI when a specific state changes.
///
/// ```dart
/// YunoEnrollmentListener(
///   listener: (state) {
///     // Handle [state] it is YunoEnrollmentState
///     // - [enrollmentStatus]: [reject,succeeded,fail,processing,internalError,cancelByUser]
///   },
///   child: SomeWidget(),
/// )
/// ```
///
/// The `YunoEnrollmentListener` widget essentially wraps its `child` and can be
/// extended to include additional logic for Enrollment state handling in the future.
///
/// - [child]: The widget that will be rendered as a descendant of
///   `YunoEnrollmentListener`.
/// - [listener]: The callback function that listens to state changes.
/// {@endtemplate}
class YunoEnrollmentListener extends StatefulWidget {
  /// Creates a `YunoEnrollmentListener` widget.
  ///
  /// The [child] and [listenToken] parameters are required.
  /// {@macro yuno_listener_YunoEnrollmentListener}
  const YunoEnrollmentListener({
    super.key,
    required this.listener,
    required this.child,
  });

  /// The widget that will be displayed as the child of this `YunoEnrollmentListener`.
  final Widget child;

  /// The callback function that listens for enrollment state changes.
  final YunoEnrollmentWidgetListener listener;

  @override
  State<YunoEnrollmentListener> createState() => _YunoPaymentListenerState();
}

class _YunoPaymentListenerState extends State<YunoEnrollmentListener> {
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

  /// The controller managing the enrollment method state.
  ///
  /// This controller handles updates to the payment method display,
  /// including changes in size and content.
  YunoEnrollmentNotifier get _controller =>
      YunoPlatform.instance.enrollmentController;
}
