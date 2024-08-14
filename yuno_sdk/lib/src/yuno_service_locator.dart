import 'internals.dart';

extension Sl on Never {
  static Future<void> init({required YunoSdkType sdkType}) async {
    _instance.registerLazySingleton<YunoChannels>(
      () => YunoChannelMethods(
        sdkType: sdkType,
      ),
    );
  }

  static void reset() async {
    _instance.reset();
  }

  static final _instance = Injector();
  static Injector get instance => _instance;
}
