part of '../widgets/yuno_listener.dart';

final class _YunoController {
  _YunoController._();
  static final _YunoController instance = _YunoController._();

  final YunoPlatform _platform = YunoPlatform.instance;

  YunoNotifier get controller => _platform.controller;
}
