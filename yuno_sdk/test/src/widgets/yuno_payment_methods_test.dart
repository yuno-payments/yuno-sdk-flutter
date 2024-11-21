import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yuno/src/internals.dart';
import 'package:yuno/yuno.dart';

class MockAndroidViewController extends Mock implements AndroidViewController {}

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
      expect(find.byType(UiKitView), findsOneWidget);

      debugDefaultTargetPlatformOverride = null;
    },
  );

  testWidgets('YunoPaymentMethods creates platform view on Android',
      (WidgetTester tester) async {
    const config = PaymentMethodConf(
      checkoutSession: 'test-session-456',
      countryCode: 'CA',
    );

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
    const config = PaymentMethodConf(
      checkoutSession: 'test-session-789',
      countryCode: 'UK',
    );

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

  testWidgets('YunoPaymentMethods updates width when constraints change',
      (WidgetTester tester) async {
    const config = PaymentMethodConf(
      checkoutSession: 'test-session-width',
      countryCode: 'US',
    );

    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    double initialWidth = 200;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: initialWidth,
            child: YunoPaymentMethods(
              config: config,
              listener: mockListener,
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    expect(YunoPaymentMethodPlatform.controller.value.width, initialWidth);
    double newWidth = 300;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: newWidth,
            child: YunoPaymentMethods(
              config: config,
              listener: mockListener,
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(YunoPaymentMethodPlatform.controller.value.width, newWidth);

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('YunoPaymentMethods removes listener on dispose',
      (WidgetTester tester) async {
    const config = PaymentMethodConf(
      checkoutSession: 'test-session-dispose',
      countryCode: 'US',
    );
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    final key = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YunoPaymentMethods(
            key: key,
            config: config,
            listener: mockListener,
          ),
        ),
      ),
    );

    await tester.pump();
    YunoPaymentMethodPlatform.selectController.value =
        const YunoPaymentSelectState(isSelected: true);

    await tester.pump();
    expect(listenerCalled, isTrue);
    listenerCalled = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Container(),
        ),
      ),
    );

    await tester.pump();
    YunoPaymentMethodPlatform.selectController.value =
        const YunoPaymentSelectState(isSelected: false);

    await tester.pump();
    expect(listenerCalled, isFalse);

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets(
      'YunoPaymentMethods handles all AndroidPlatformViewRenderType cases',
      (WidgetTester tester) async {
    const config = PaymentMethodConf(
      checkoutSession: 'test-session-switch',
      countryCode: 'US',
    );
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    for (var renderType in AndroidPlatformViewRenderType.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: YunoPaymentMethods(
              config: config,
              listener: mockListener,
              androidPlatformViewRenderType: renderType,
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(PlatformViewLink), findsOneWidget);
    }

    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets(
      'YunoPaymentMethods creates Android PlatformViewLink with correct viewType',
      (WidgetTester tester) async {
    const config = PaymentMethodConf(
      checkoutSession: 'test-session',
      countryCode: 'US',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YunoPaymentMethods(
            config: config,
            listener: (_, __) {},
            androidPlatformViewRenderType:
                AndroidPlatformViewRenderType.expensiveAndroidView,
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.byType(PlatformViewLink), findsOneWidget);

    final platformViewLink =
        tester.widget<PlatformViewLink>(find.byType(PlatformViewLink));
    expect(platformViewLink.viewType, YunoPaymentMethodPlatform.viewType);
  });
}
