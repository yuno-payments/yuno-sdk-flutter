import 'package:flutter/material.dart';
import 'package:yuno/src/internals.dart';
part '../channels/yuno_controller.dart';

/// Signature for the `listener` function which takes the `BuildContext` along
/// with the `state` and is responsible for executing in response to
/// `state` changes.
typedef YunoWidgetListener = void Function(
    BuildContext context, YunoState state);

/// {@template yuno_listener_YunoListener}
/// A widget that listens for a token change and provides a child widget.
///
/// The `YunoListener` widget is a `StatelessWidget` that takes a child widget
/// and a callback function `listenToken` as required parameters. The widget
/// itself does not perform any actions but can be extended or used as a
/// placeholder where a token listening mechanism is needed.
///
/// This widget can be useful in scenarios where you need to trigger certain
/// actions or updates in the UI when a specific token changes.
///
/// ```dart
/// YunoListener(
///   listenToken: (token) {
///     // Handle token changes here
///   },
///   child: SomeWidget(),
/// )
/// ```
///
/// The `YunoListener` widget essentially wraps its `child` and can be
/// extended to include additional logic for token handling in the future.
///
/// - [child]: The widget that will be rendered as a descendant of
///   `YunoListener`.
/// - [listenToken]: The callback function that listens to token changes.
/// {@endtemplate}
class YunoListener extends StatefulWidget {
  /// Creates a `YunoListener` widget.
  ///
  /// The [child] and [listenToken] parameters are required.
  /// {@macro yuno_listener_YunoListener}
  const YunoListener({
    super.key,
    required this.listener,
    // required this.listeResult,
    required this.child,
  });

  /// The widget that will be displayed as the child of this `YunoListener`.
  final Widget child;

  /// The callback function that listens for token changes.
  final YunoWidgetListener listener;

  /// The callback function that listens for result changes.
  // final ResultBuilder listeResult;

  @override
  State<YunoListener> createState() => _YunoListenerState();
}

class _YunoListenerState extends State<YunoListener> {
  final controller = SampleController();
  @override
  void initState() {
    super.initState();
    _YunoController.instance.controller.addListener(_listener);
  }

  void _listener() {
    widget.listener(context, _YunoController.instance.controller.value);
  }

  @override
  Widget build(BuildContext context) {
    // Currently, this widget just returns the child.
    // You can add token listening logic here if needed.
    return widget.child;
  }

  @override
  void dispose() {
    _YunoController.instance.controller.removeListener(_listener);
    super.dispose();
  }
}
