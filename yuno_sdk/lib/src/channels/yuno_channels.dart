import '../internals.dart';

abstract interface class Yuno {
  static Future<Yuno> init({
    required String apiKey,
    required YunoSdkType sdkType,
    IosConfig iosConfig = const IosConfig(),
    AndroidConfig androidConfig = const AndroidConfig(),
  }) async {
    final yuno = _YunoChannels(sdkType: sdkType);
    await yuno.init(
      apiKey: apiKey,
      iosConfig: iosConfig,
      androidConfig: androidConfig,
    );
    return yuno;
  }

  Future<void> openPaymentMethodsScreen();
}

final class _YunoChannels implements Yuno {
  const _YunoChannels({
    required this.sdkType,
  });
  final YunoSdkType sdkType;
  static YunoPlatform? __platform;
  static YunoPlatform get _platform {
    __platform ??= YunoPlatform.instance;
    return __platform!;
  }

  Future<void> init({
    required String apiKey,
    IosConfig? iosConfig,
    AndroidConfig? androidConfig,
  }) async {
    await _platform.initialize(
      apiKey: apiKey,
      iosConfig: iosConfig,
      androidConfig: androidConfig,
    );
  }

  @override
  Future<void> openPaymentMethodsScreen() {
    if (sdkType == YunoSdkType.lite) {
      throw YunoNotSupport();
    } else {}

    throw UnimplementedError();
  }
}
