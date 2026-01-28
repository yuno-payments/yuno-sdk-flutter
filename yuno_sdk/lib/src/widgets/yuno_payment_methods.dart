import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:yuno/src/internals.dart';

/// Signature for the `listener` function which takes the `BuildContext` along
/// with the `methodSelected` state and `height` and is responsible for executing in response to
/// state changes.
typedef YunoPaymentMethodSelectedWidgetListener = void Function(
    BuildContext context, MethodSelected? methodSelected, double height);

/// A Flutter widget that displays payment methods using a native iOS and Android views.
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
///   listener: (context, methodSelected, height) {
///     if (methodSelected != null) {
///       print('Payment method selected: ${methodSelected.paymentMethodType}');
///       print('Vaulted token: ${methodSelected.vaultedToken}');
///     } else {
///       print('No payment method is currently selected');
///     }
///     print('Payment methods height: $height');
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
  /// The function is passed the current [BuildContext] and a [MethodSelected] object
  /// containing the selected payment method information (vaultedToken and paymentMethodType).
  /// This can be used to update the UI or perform actions based on the selection state.
  ///
  /// Example:
  /// ```dart
/// (context, methodSelected, height) {
///   if (methodSelected != null) {
///     ScaffoldMessenger.of(context).showSnackBar(
///       SnackBar(
///         content: Text('Payment method selected: ${methodSelected.paymentMethodType}'),
///       ),
///     );
///   }
///   // Use height to adjust UI layout
/// }
  /// ```
  final YunoPaymentMethodSelectedWidgetListener listener;

  /// Type of platformview used for rendering on Android.
  ///
  /// This is an advanced option and changing this should be tested on multiple android devices.
  /// Defaults to [AndroidPlatformViewRenderType.androidView]
  final AndroidPlatformViewRenderType androidPlatformViewRenderType;

  @override
  State<YunoPaymentMethods> createState() => _YunoPaymentMethodsState();
}

class _YunoPaymentMethodsState extends State<YunoPaymentMethods> {
  @override
  void initState() {
    super.initState();
    // Reset height to initial value when widget is initialized
    // This ensures each new widget instance starts with the correct initial height
    // instead of keeping the previous value from a previous widget instance
    _controller.resetHeight();
    _selectController.addListener(_listener);
    _controller.addListener(_listener);
  }

  /// Listener method called when the payment method state changes.
  ///
  /// This method invokes the [YunoPaymentMethodSelectedWidgetListener] provided in the widget
  /// constructor, passing the current context, the selected payment method information, and the height.
  /// It allows the parent widget to react to changes in the payment method selection and height.
  void _listener() {
    widget.listener(
      context,
      _selectController.value.methodSelected,
      _controller.value.height,
    );
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

          // Helper function to create the platform view
          Widget createPlatformView() {
            return PlatformViewLink(
              viewType: YunoPaymentMethodPlatform.viewType,
              surfaceFactory: (context, controller) => AndroidViewSurface(
                controller: controller as AndroidViewController,
                gestureRecognizers: const <Factory<
                    OneSequenceGestureRecognizer>>{},
                hitTestBehavior: PlatformViewHitTestBehavior.opaque,
              ),
              onCreatePlatformView: (params) {
                YunoPaymentMethodPlatform.init(params.id);
                final Map<String, dynamic> creationParams =
                    widget.config.toMap(currentWidth: currentWidth);
                switch (widget.androidPlatformViewRenderType) {
                  case AndroidPlatformViewRenderType.expensiveAndroidView:
                    return PlatformViewsService.initExpensiveAndroidView(
                      id: params.id,
                      viewType: YunoPaymentMethodPlatform.viewType,
                      layoutDirection: Directionality.of(context),
                      creationParams: creationParams,
                      creationParamsCodec: const StandardMessageCodec(),
                    )
                      ..addOnPlatformViewCreatedListener(
                          params.onPlatformViewCreated)
                      ..create();

                  case AndroidPlatformViewRenderType.androidView:
                    return PlatformViewsService.initAndroidView(
                      id: params.id,
                      viewType: YunoPaymentMethodPlatform.viewType,
                      layoutDirection: Directionality.of(context),
                      creationParams: creationParams,
                      creationParamsCodec: const StandardMessageCodec(),
                    )
                      ..addOnPlatformViewCreatedListener(
                          params.onPlatformViewCreated)
                      ..create();
                }
              },
            );
          }

          final Widget paymentMethodsView =
              TargetPlatform.iOS == defaultTargetPlatform
                  ? SizedBox(
                      // iOS starts with height 0 until the native side reports the real size.
                      // Use a tiny non-zero height to avoid layout edge cases, then update via onHeightChange.
                      height: value.height > 0 ? value.height : 1,
                      child: ClipRect(
                        child: UiKitView(
                          key: ValueKey(currentWidth),
                          onPlatformViewCreated: YunoPaymentMethodPlatform.init,
                          creationParamsCodec: const StandardMessageCodec(),
                          creationParams: widget.config.toMap(
                            currentWidth: currentWidth,
                          ),
                          viewType: YunoPaymentMethodPlatform.viewType,
                        ),
                      ),
                    )
                  : value.height > 50
                      ? AnimatedContainer(
                          curve: Curves.easeInOut,
                          duration: const Duration(milliseconds: 250),
                          height: value.height,
                          child: ClipRect(
                            child: createPlatformView(),
                          ),
                        )
                      : SizedBox(
                          // Cuando la altura es muy pequeña, usamos un espacio grande para permitir
                          // que el componente nativo mida su contenido real
                          height: 2000.0,
                          child: ClipRect(
                            child: createPlatformView(),
                          ),
                        );

          return paymentMethodsView;
        },
      );
    },
  );
}

  /// The controller managing the payment method state.
  ///
  /// This controller handles updates to the payment method display,
  /// including changes in size and content.
  YunoPaymentMethodSelectNotifier get _controller =>
      YunoPaymentMethodPlatform.controller;

  /// The controller managing the payment method selection state.
  ///
  /// This controller tracks whether a payment method is currently selected
  /// and notifies listeners of changes to this state.
  YunoPaymentSelectNotifier get _selectController =>
      YunoPaymentMethodPlatform.selectController;

  @override
  void dispose() {
    _selectController.removeListener(_listener);
    _controller.removeListener(_listener);
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
