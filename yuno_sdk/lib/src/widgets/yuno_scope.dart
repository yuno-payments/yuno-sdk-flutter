import 'package:flutter/material.dart';
import '../internals.dart';

/// {@template yuno_scope_YunoScope}
/// An injector of the [Yuno] object
///
/// {@tool snippet}
/// ```dart
/// Future<void> main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   final yuno = await Yuno.init(...);
///   return runApp(
///     YunoScope(
///       yuno: yuno,
///       child: MaterialApp(...),
///     ),
///   );
/// }
/// ```
/// {@end-tool}
/// {@endtemplate}
class YunoScope extends InheritedWidget {
  /// {@macro yuno_scope_YunoScope}
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

  @visibleForTesting
  Yuno get yuno => YunoScope.of(this);
  Future<void> startPaymentLite(
          {required StartPayment arguments, String countryCode = ''}) =>
      yuno.startPaymentLite(
        arguments: arguments,
        countryCode: countryCode,
      );
  Future<void> continuePayment() async => await yuno.continuePayment();

  Future<void> openPaymentMethodsScreen({
    required PaymentMethodsArgs arguments,
  }) async =>
      yuno.openPaymentMethodsScreen(arguments: arguments);
}
