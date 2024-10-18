import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yuno/yuno.dart';

void main() {
  late MockYunoWrapper mockYunoWrapper;

  setUpAll(() {
    registerFallbackValue(
      const StartPayment(
        checkoutSession: '',
        methodSelected: MethodSelected(paymentMethodType: 'PIX'),
      ),
    );
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  setUp(() {
    mockYunoWrapper = MockYunoWrapper();
  });

  group('YunoReader Extension Tests', () {
    test('startPaymentLite is called with correct arguments', () async {
      const startPaymentArgs = StartPayment(
        checkoutSession: '',
        methodSelected: MethodSelected(paymentMethodType: 'PIX'),
      );
      const countryCode = 'US';

      when(() => mockYunoWrapper.startPaymentLite(
          arguments: any(named: 'arguments'),
          countryCode: any(named: 'countryCode'))).thenAnswer((_) async {});

      await mockYunoWrapper.startPaymentLite(
          arguments: startPaymentArgs, countryCode: countryCode);

      verify(() => mockYunoWrapper.startPaymentLite(
          arguments: startPaymentArgs, countryCode: countryCode)).called(1);
    });

    test('startPayment is called with default parameters', () async {
      when(() => mockYunoWrapper.startPayment(
              showPaymentStatus: any(named: 'showPaymentStatus')))
          .thenAnswer((_) async {});

      await mockYunoWrapper.startPayment();

      verify(() => mockYunoWrapper.startPayment(showPaymentStatus: true))
          .called(1);
    });

    test('continuePayment is called', () async {
      when(() => mockYunoWrapper.continuePayment(
              showPaymentStatus: any(named: 'showPaymentStatus')))
          .thenAnswer((_) async {});

      await mockYunoWrapper.continuePayment();

      verify(() => mockYunoWrapper.continuePayment(showPaymentStatus: true))
          .called(1);
    });
  });
}

class MockBuildContext extends Mock implements BuildContext {}

class MockYunoWrapper extends Mock implements YunoWrapper {}

class YunoWrapper {
  Future<void> startPaymentLite({
    required StartPayment arguments,
    String countryCode = '',
  }) async {
    await Yuno.startPaymentLite(arguments: arguments, countryCode: countryCode);
  }

  Future<void> startPayment({bool showPaymentStatus = true}) async {
    await Yuno.startPayment(showPaymentStatus: showPaymentStatus);
  }

  Future<void> continuePayment({bool showPaymentStatus = true}) async {
    await Yuno.continuePayment(showPaymentStatus: showPaymentStatus);
  }

  Future<void> hideLoader() async {
    await Yuno.hideLoader();
  }

  Future<void> receiveDeeplink({required Uri url}) async {
    await Yuno.receiveDeeplink(url: url);
  }
}
