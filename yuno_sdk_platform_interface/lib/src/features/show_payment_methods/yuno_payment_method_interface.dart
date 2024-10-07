import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:yuno_sdk_platform_interface/lib.dart';

abstract interface class YunoPaymentMethodPlatform extends PlatformInterface {
  /// Constructs a YunoPaymentMethodPlatform.
  YunoPaymentMethodPlatform() : super(token: _token);

  static final Object _token = Object();
  static YunoPaymentMethodPlatform init(
    int viewId,
  ) {
    final instance =
        const YunoPaymentMethodChannelFactory().create(viewId: viewId);
    instance.setMethodCallHandler();
    return instance;
  }

  static const _viewType = 'yuno/payment_methods_view';
  static String get viewType => _viewType;
  void setMethodCallHandler();
  static YunoPaymentNotifier get controller => _controller;
  static final _controller = YunoPaymentNotifier();
  static YunoPaymentSelectNotifier get selectController => _selectController;
  static final _selectController = YunoPaymentSelectNotifier();
}
