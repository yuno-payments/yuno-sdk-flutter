import 'package:flutter/material.dart';
import '../internals.dart';

/// {@template yuno_provider_YunoReader}
/// An easy way to interact with the [Yuno] object directly from the [BuildContext].
///
/// This extension provides convenient methods to start or continue payments using the Yuno SDK
/// by simply calling the respective methods on the context.
///
/// Example usage:
/// ```dart
/// Widget build(BuildContext context) {
///   return Column(
///     children: [
///       TextButton(
///         onPressed: () => context.startPaymentLite(arguments: StartPayment()),
///         child: Text('Start Payment Lite'),
///       ),
///       TextButton(
///         onPressed: () => context.startPayment(),
///         child: Text('Start Payment'),
///       ),
///       TextButton(
///         onPressed: () => context.continuePayment(),
///         child: Text('Continue Payment'),
///       ),
///     ],
///   );
/// }
/// ```
/// {@endtemplate}
extension YunoReader on BuildContext {
  /// {@macro yuno_provider_YunoReader}
  ///
  /// Starts a lightweight payment process using the Yuno SDK.
  ///
  /// ### Parameters:
  /// - [arguments]: The [StartPayment] object containing information about the payment session and selected method.
  /// - [countryCode]: The optional country code (e.g., 'US'). Defaults to an empty string if not provided.
  ///
  /// Example usage:
  /// ```dart
  /// context.startPaymentLite(arguments: StartPayment());
  /// ```
  Future<void> startPaymentLite({
    required StartPayment arguments,
    String countryCode = '',
  }) async =>
      await Yuno.startPaymentLite(
        arguments: arguments,
        countryCode: countryCode,
      );

  /// Starts a full payment process using the Yuno SDK.
  ///
  /// ### Parameters:
  /// - [showPaymentStatus]: Boolean indicating whether to show payment status. Defaults to `true`.
  ///
  /// Example usage:
  /// ```dart
  /// context.startPayment(showPaymentStatus: true);
  /// ```
  Future<void> startPayment({
    bool showPaymentStatus = true,
  }) async =>
      await Yuno.startPayment(
        showPaymentStatus: showPaymentStatus,
      );

  /// Continues an ongoing payment process using the Yuno SDK.
  ///
  /// Example usage:
  /// ```dart
  /// context.continuePayment();
  /// ```
  Future<void> continuePayment({bool showPaymentStatus = true}) async =>
      await Yuno.continuePayment(showPaymentStatus: showPaymentStatus);

  /// Receives a deep link to continue a payment process using the Yuno SDK.
  ///
  /// #### This method works only for iOS devices.
  ///
  /// #### Parameters:
  /// - [url]: The [Uri] object containing the deep link information.
  ///
  /// Example usage:
  /// ```dart
  /// context.receiveDeeplink(url: Uri.parse('https://example.com'));
  /// ```
  Future<void> receiveDeeplink({required Uri url}) async =>
      await Yuno.receiveDeeplink(url: url);

  /// Hides the loader displayed by the Yuno SDK.
  ///
  /// Example usage:
  /// ```dart
  /// context.hideLoader();
  /// ```
  Future<void> hideLoader() async => await Yuno.hideLoader();

  /// Initiates the enrollment payment process.
  ///
  /// The `arguments` parameter contains the required details for initiating enrollment.
  ///
  /// ### Parameters:
  /// - `arguments`: An instance of `EnrollmentArguments` containing the enrollment details.
  ///
  /// ### Example usage:
  /// ```dart
  /// await Yuno.enrollmentPayment(
  ///   arguments: EnrollmentArguments(customerSession: 'session', showPaymentStatus: true),
  /// );
  /// ```
  Future<void> enrollmentPayment({
    required EnrollmentArguments arguments,
  }) async =>
      await Yuno.enrollmentPayment(arguments: arguments);
}
