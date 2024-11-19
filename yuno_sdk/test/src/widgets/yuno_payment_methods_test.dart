import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yuno/yuno.dart';

void main() {
  late bool listenerCalled;
  late YunoPaymentMethodSelectedWidgetListener mockListener;

  setUp(() {
    listenerCalled = false;
    mockListener = (context, isSelected) {
      listenerCalled = true;
    };
    Yuno.init(apiKey: '', countryCode: 'CO');
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets(
    'YunoPaymentMethods creates platform view on iOS',
    (WidgetTester tester) async {
      // Create a real PaymentMethodConf with fake data
      const config = PaymentMethodConf(
        checkoutSession: 'test-session-123',
        countryCode: 'CO',
      );

      // Override platform to iOS
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: YunoPaymentMethods(
              config: config,
              listener: mockListener,
            ),
          ),
        ),
      );
      await tester.pump();
      // Verify UiKitView is created
      expect(find.byType(UiKitView), findsOneWidget);

      debugDefaultTargetPlatformOverride = null;
    },
  );

  testWidgets('YunoPaymentMethods creates platform view on Android',
      (WidgetTester tester) async {
    // Create a real PaymentMethodConf with fake data
    const config = PaymentMethodConf(
      checkoutSession: 'test-session-456',
      countryCode: 'CA',
    );

    // Override platform to Android
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YunoPaymentMethods(
            config: config,
            listener: mockListener,
            androidPlatformViewRenderType:
                AndroidPlatformViewRenderType.androidView,
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(PlatformViewLink), findsOneWidget);
    debugDefaultTargetPlatformOverride = null;
  }, variant: TargetPlatformVariant.only(TargetPlatform.android));

  testWidgets('YunoPaymentMethods handles different Android render types',
      (WidgetTester tester) async {
    // Create a real PaymentMethodConf with fake data
    const config = PaymentMethodConf(
      checkoutSession: 'test-session-789',
      countryCode: 'UK',
    );

    // Override platform to Android
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YunoPaymentMethods(
            config: config,
            listener: mockListener,
            androidPlatformViewRenderType:
                AndroidPlatformViewRenderType.expensiveAndroidView,
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(PlatformViewLink), findsOneWidget);
    debugDefaultTargetPlatformOverride = null;
  });
}
