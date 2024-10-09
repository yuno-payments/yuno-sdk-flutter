import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
/// The widget provides a listener to notify about selection changes, allowing
/// the parent widget to react to user interactions with the payment methods.
///
/// Usage:
/// ```dart
/// YunoPaymentMethods(
///   config: PaymentMethodConf(
///     checkoutSession: 'your_checkout_session_id',
///     // Add other configuration options as needed
///   ),
///   listener: (context, isSelected) {
///     if (isSelected) {
///       print('A payment method has been selected');
///     } else {
///       print('No payment method is currently selected');
///     }
///   },
/// )
/// ```
///
/// The widget listens to changes in the payment method state and rebuilds accordingly.
/// This ensures that the UI always reflects the current state of the payment methods.
class YunoPaymentMethods extends StatefulWidget {
  /// Creates a YunoPaymentMethods widget.
  ///
  /// The [config] parameter is required and represents the configuration
  /// for the payment methods display, including the checkout session ID
  /// and any other custom settings.
  ///
  /// The [listener] parameter is required and will be called whenever the
  /// selection state of the payment methods changes.
  const YunoPaymentMethods({
    super.key,
    required this.config,
    this.androidPlatformViewRenderType =
        AndroidPlatformViewRenderType.androidView,
    required this.listener,
  });

  /// The configuration for the payment methods display.
  ///
  /// This includes settings such as the checkout session ID, styling options,
  /// and any other parameters required by the Yuno SDK.
  final PaymentMethodConf config;

  /// A function that is called when the payment method selection changes.
  ///
  /// The function is passed the current [BuildContext] and a boolean indicating
  /// whether a payment method is selected. This can be used to update the UI
  /// or perform actions based on the selection state.
  ///
  /// Example:
  /// ```dart
  /// (context, isSelected) {
  ///   if (isSelected) {
  ///     ScaffoldMessenger.of(context).showSnackBar(
  ///       SnackBar(content: Text('Payment method selected')),
  ///     );
  ///   }
  /// }
  /// ```
  final YunoPaymentWidgetListener listener;

  /// Type of platformview used for rendering on Android.
  ///
  /// This is an advanced option and changing this should be tested on multiple android devices.
  /// Defaults to [AndroidPlatformViewRenderType.expensiveAndroidView]
  final AndroidPlatformViewRenderType androidPlatformViewRenderType;

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
  /// It allows the parent widget to react to changes in the payment method selection.
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
              constraints: Platform.isIOS
                  ? BoxConstraints.expand(height: value.height)
                  : const BoxConstraints.expand(height: _kMinimunHeight),
              child: Platform.isIOS
                  ? UiKitView(
                      key: ValueKey(currentWidth),
                      onPlatformViewCreated: YunoPaymentMethodPlatform.init,
                      viewType: YunoPaymentMethodPlatform.viewType,
                      creationParamsCodec: const StandardMessageCodec(),
                      creationParams: widget.config.toMap(
                        currentWidth: currentWidth,
                      ),
                    )
                  : PlatformViewLink(
                      viewType: YunoPaymentMethodPlatform.viewType,
                      surfaceFactory: (context, controller) =>
                          AndroidViewSurface(
                        controller: controller as AndroidViewController,
                        gestureRecognizers: const <Factory<
                            OneSequenceGestureRecognizer>>{},
                        hitTestBehavior: PlatformViewHitTestBehavior.opaque,
                      ),
                      onCreatePlatformView: (params) {
                        YunoPaymentMethodPlatform.init(params.id);

                        switch (widget.androidPlatformViewRenderType) {
                          case AndroidPlatformViewRenderType
                                .expensiveAndroidView:
                            return PlatformViewsService
                                .initExpensiveAndroidView(
                              id: params.id,
                              viewType: YunoPaymentMethodPlatform.viewType,
                              layoutDirection: Directionality.of(context),
                              creationParams: widget.config
                                  .toMap(currentWidth: currentWidth),
                              creationParamsCodec: const StandardMessageCodec(),
                              onFocus: () {
                                params.onFocusChanged(true);
                              },
                            )
                              ..addOnPlatformViewCreatedListener(
                                  params.onPlatformViewCreated)
                              ..create();

                          case AndroidPlatformViewRenderType.androidView:
                            return PlatformViewsService.initAndroidView(
                              id: params.id,
                              viewType: YunoPaymentMethodPlatform.viewType,
                              layoutDirection: Directionality.of(context),
                              creationParams: widget.config
                                  .toMap(currentWidth: currentWidth),
                              creationParamsCodec: const StandardMessageCodec(),
                              onFocus: () {
                                params.onFocusChanged(true);
                              },
                            )
                              ..addOnPlatformViewCreatedListener(
                                  params.onPlatformViewCreated)
                              ..create();
                        }
                      },
                    ),
            );
          },
        );
      },
    );
  }

  /// The controller managing the payment method state.
  ///
  /// This controller handles updates to the payment method display,
  /// including changes in size and content.
  YunoPaymentNotifier get _controller => YunoPaymentMethodPlatform.controller;

  /// The controller managing the payment method selection state.
  ///
  /// This controller tracks whether a payment method is currently selected
  /// and notifies listeners of changes to this state.
  YunoPaymentSelectNotifier get _selectController =>
      YunoPaymentMethodPlatform.selectController;

  @override
  void dispose() {
    _selectController.removeListener(_listener);
    super.dispose();
  }
}

enum AndroidPlatformViewRenderType {
  /// Controls an Android view that is composed using the Android view hierarchy
  expensiveAndroidView,

  /// Use an Android view composed using a GL texture.
  ///
  /// This is more efficient but has more issues on older Android devices.
  androidView,
}

const _kMinimunHeight = 120.0;
