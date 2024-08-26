part of '../widgets/yuno_listener.dart';

final class _YunoController {
  _YunoController._();
  static final _YunoController instance = _YunoController._();

  final YunoPlatform _platform = YunoPlatform.instance;

  YunoNotifier get controller => _platform.controller;
}

class SampleController extends _YunoChangeNotifier {
  @override
  void attach(YunoNotifier state) {
    super.attach(state);
    print(state.value);
  }
}

class _YunoChangeNotifier extends ChangeNotifier {
  final YunoPlatform _platform = YunoPlatform.instance;

  void attach(YunoNotifier state) {
    state.addListener(notifyListeners);
  }

  void detach(YunoNotifier state) {
    state.removeListener(notifyListeners);
  }
}
