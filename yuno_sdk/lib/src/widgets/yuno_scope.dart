import 'package:flutter/material.dart';
import '../internals.dart';

/// {@template yuno_provider_YunoProvider}
/// An injector of the [Yuno] object
///
/// ```
/// Future<void> main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   final yuno = await Yuno.init(...);
///   return runApp(
///     YunoScope(
///       yuno,
///       child: MaterialApp(...),
///     ),
///   );
/// }
/// ```
/// {@endtemplate}
class YunoScope extends InheritedWidget {
  /// {@macro yuno_provider_YunoProvider}
  const YunoScope({
    super.key,
    required this.yuno,
    required super.child,
  });

  final Yuno yuno;

  @override
  bool updateShouldNotify(covariant YunoScope oldWidget) {
    return yuno != oldWidget.yuno;
  }

  static Yuno of(BuildContext context) {
    final provider = context.getInheritedWidgetOfExactType<YunoScope>();
    if (provider == null) {
      throw YunoNotFoundError();
    }
    return provider.yuno;
  }
}

/// The handler for using the Yuno plugin
// mixin Yuno {
//   void openYunoScreen();
// }

/// {@template yuno_provicer_YunoReader}
/// An easy way to get the [Yuno] object from [BuildContext]
/// ```
/// Widget build(BuildContext context) {
///   final yuno = context.yuno();
///   return Container();
/// }
/// ```
/// {@endtemplate}
extension YunoReader on BuildContext {
  /// {@macro yuno_provicer_YunoReader}
  Yuno yuno() => YunoScope.of(this);
}
