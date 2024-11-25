import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yuno/yuno.dart';

import '../utils/mock_yuno_platform.dart';

class MockBuildContext extends Mock implements BuildContext {}

class MockYunoWrapper extends Mock implements YunoWrapper {}

class MockYuno extends Mock implements Yuno {}

void main() {
  late MockYunoWrapper mockYunoWrapper;
  late MockYunoPlatform mockYunoPlatform;

  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    registerFallbackValue(
      const StartPayment(
        checkoutSession: '',
        methodSelected: MethodSelected(paymentMethodType: 'PIX'),
      ),
    );
    registerFallbackValue(Uri.parse('https://example.com'));
    registerFallbackValue(
        const EnrollmentArguments(customerSession: 'session'));
  });

  setUp(() {
    mockYunoWrapper = MockYunoWrapper();

    mockYunoPlatform = MockYunoPlatform();
  });

  group('YunoReader Extension Tests', () {
    testWidgets('startPaymentLite is called with correct arguments',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (BuildContext context) {
            const startPaymentArgs = StartPayment(
              checkoutSession: 'test-session',
              methodSelected: MethodSelected(paymentMethodType: 'PIX'),
            );
            const countryCode = 'US';

            // Mock
            when(() => mockYunoPlatform.startPaymentLite(
                  arguments: startPaymentArgs,
                  countryCode: countryCode,
                )).thenAnswer((_) async {});

            when(() => mockYunoWrapper.startPaymentLite(
                  arguments: startPaymentArgs,
                  countryCode: countryCode,
                )).thenAnswer((_) async {});

            // When
            context.startPaymentLite(
                arguments: startPaymentArgs, countryCode: countryCode);

            // Then
            verifyNever(() => mockYunoPlatform.startPaymentLite(
                  arguments: startPaymentArgs,
                  countryCode: countryCode,
                ));

            // The builder function must return a widget.
            return const Placeholder();
          },
        ),
      );
    });

    testWidgets('startPayment is called with correct arguments',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (BuildContext context) {
            // Mock
            when(() => mockYunoPlatform.startPayment())
                .thenAnswer((_) async {});

            when(() => mockYunoWrapper.startPayment()).thenAnswer((_) async {});

            // When
            context.startPayment();

            // Then
            verifyNever(() => mockYunoPlatform.startPayment());

            // The builder function must return a widget.
            return const Placeholder();
          },
        ),
      );
    });

    testWidgets('continuePayment is called with correct arguments',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (BuildContext context) {
            // Mock
            when(() => mockYunoPlatform.continuePayment())
                .thenAnswer((_) async {});

            when(() => mockYunoWrapper.continuePayment())
                .thenAnswer((_) async {});

            // When
            context.continuePayment();

            // Then
            verifyNever(() => mockYunoPlatform.continuePayment());

            // The builder function must return a widget.
            return const Placeholder();
          },
        ),
      );
    });

    testWidgets('receiveDeeplink is called with correct arguments',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (BuildContext context) {
            // Mock
            when(
              () => mockYunoPlatform.receiveDeeplink(
                url: Uri.parse('https://example.com'),
              ),
            ).thenAnswer((_) async {});

            when(
              () => mockYunoWrapper.receiveDeeplink(
                url: Uri.parse('https://example.com'),
              ),
            ).thenAnswer((_) async {});

            // When
            context.receiveDeeplink(url: Uri.parse('https://example.com'));

            // Then
            verifyNever(
              () => mockYunoPlatform.receiveDeeplink(
                url: Uri.parse('https://example.com'),
              ),
            );

            // The builder function must return a widget.
            return const Placeholder();
          },
        ),
      );
    });

    testWidgets('hideLoader is called with correct arguments',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (BuildContext context) {
            // Mock
            when(
              () => mockYunoPlatform.hideLoader(),
            ).thenAnswer((_) async {});

            when(
              () => mockYunoWrapper.hideLoader(),
            ).thenAnswer((_) async {});

            // When
            context.hideLoader();

            // Then
            verifyNever(
              () => mockYunoPlatform.hideLoader(),
            );

            // The builder function must return a widget.
            return const Placeholder();
          },
        ),
      );
    });

    testWidgets('hideLoader is called with correct arguments',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (BuildContext context) {
            const arguments = EnrollmentArguments(
                customerSession: 'session', countryCode: 'US');
            // Mock
            when(
              () => mockYunoPlatform.enrollmentPayment(arguments: arguments),
            ).thenAnswer((_) async {});

            when(
              () => mockYunoWrapper.enrollmentPayment(arguments: arguments),
            ).thenAnswer((_) async {});

            // When
            context.enrollmentPayment(arguments: arguments);

            // Then
            verifyNever(
              () => mockYunoPlatform.enrollmentPayment(arguments: arguments),
            );

            // The builder function must return a widget.
            return const Placeholder();
          },
        ),
      );
    });
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

  Future<void> enrollmentPayment(
      {required EnrollmentArguments arguments}) async {
    await Yuno.enrollmentPayment(arguments: arguments);
  }
}
