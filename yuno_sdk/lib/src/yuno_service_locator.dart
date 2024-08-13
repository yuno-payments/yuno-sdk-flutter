import 'internals.dart';

extension Sl on Never {
  static Future<void> init({required YunoSdkType sdkType}) async {
    _instance.registerLazySingleton<YunoChannels>(
      () => YunoChannelMethods(
        sdkType: sdkType,
      ),
    );
  }

  static Future<void> destroy() async {
    _instance.unregister();
  }

  static final _instance = Injector();
  static Injector get instance => _instance;
}
