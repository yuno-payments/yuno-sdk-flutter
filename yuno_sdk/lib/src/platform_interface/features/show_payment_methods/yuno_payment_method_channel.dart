import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../utils/yuno_payment_method_select_notifier.dart';
import '../../utils/yuno_payment_select_notifier.dart';
import 'yuno_payment_method_interface.dart';
import '../start_payment_lite/models/payment_method.dart';

final class YunoPaymentMethodChannel implements YunoPaymentMethodPlatform {
  /// The method channel used to interact with the native platform.

  YunoPaymentMethodChannel({
    required MethodChannel methodChannel,
    required bool platformIsIos,
    required bool platformIsAndroid,
  })  : _methodChannel = methodChannel,
        _platformIsAndroid = platformIsAndroid,
        _platformIsIos = platformIsIos;

  @visibleForTesting
  bool get isIos => _platformIsIos;
  @visibleForTesting
  bool get isAndroid => _platformIsAndroid;

  final MethodChannel _methodChannel;
  final bool _platformIsIos;
  final bool _platformIsAndroid;

  @override
  void setMethodCallHandler() {
    _methodChannel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case 'onHeightChange':
          if (call.arguments is! double) return;
          final height = call.arguments as double;
          controller.updateHeight(height.toDouble());
          break;

        case 'onSelected':
          if (call.arguments is Map) {
            final args = call.arguments as Map<dynamic, dynamic>;
            final vaultedToken = args['vaultedToken'] as String?;
            final paymentMethodType = args['paymentMethodType'] as String? ?? '';
            final methodSelected = paymentMethodType.isNotEmpty
                ? MethodSelected(
                    vaultedToken: vaultedToken,
                    paymentMethodType: paymentMethodType,
                  )
                : null;
            selectController.methodSelectedUpdate(methodSelected);
          } else if (call.arguments is bool) {
            // Backward compatibility: if a boolean is sent, just update the selection state
            final isSelected = call.arguments as bool;
            selectController.isSelectedUpdate(isSelected);
          }
          break;

        default:
          throw MissingPluginException(
              'Not implemented method: ${call.method}');
      }
    });
  }

  final YunoPaymentMethodSelectNotifier controller =
      YunoPaymentMethodPlatform.controller;
  final YunoPaymentSelectNotifier selectController =
      YunoPaymentMethodPlatform.selectController;
}

/// {@template commons_YunoPaymentMethodChannelFactory}
/// ## YunoMethodChannelFactory
/// ```
///  static YunoPlatform _instance = const YunoPaymentMethodChannelFactory().create();
/// ```
/// {@endtemplate}
final class YunoPaymentMethodChannelFactory {
  const YunoPaymentMethodChannelFactory();

  YunoPaymentMethodPlatform create({
    required int viewId,
  }) =>
      YunoPaymentMethodChannel(
        methodChannel: MethodChannel(
          'yuno/payment_methods_view/$viewId',
        ),
        platformIsIos: Platform.isIOS,
        platformIsAndroid: Platform.isAndroid,
      );
}
