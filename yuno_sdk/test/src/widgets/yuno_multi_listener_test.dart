import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yuno/src/internals.dart';
import 'package:yuno/yuno.dart';

import '../utils/mock_yuno_platform.dart';
import 'yuno_enrollment_listener_test.dart';
import 'yuno_payment_listener_test.dart';

void main() {
  late MockYunoPlatform mockPlatform;
  late MockYunoEnrollmentNotifier mockEnrollmentNotifier;
  late MockYunoPaymentNotifier mockPaymentNotifier;

  setUp(() {
    mockPlatform = MockYunoPlatform();
    mockEnrollmentNotifier =
        mockPlatform.enrollmentController as MockYunoEnrollmentNotifier;
    mockPaymentNotifier = mockPlatform.controller as MockYunoPaymentNotifier;
    YunoPlatform.instance = mockPlatform;
  });

  testWidgets('YunoMultiListener notifies when enrollment state changes',
      (WidgetTester tester) async {
    YunoEnrollmentState? capturedEnrollmentState;
    BuildContext? capturedEnrollmentContext;

    await tester.pumpWidget(
      MaterialApp(
        home: YunoMultiListener(
          enrollmentListener: (context, state) {
            capturedEnrollmentState = state;
            capturedEnrollmentContext = context;
          },
          paymentListener: (_, __) {},
          child: const SizedBox(),
        ),
      ),
    );

    const newEnrollmentState = YunoEnrollmentState(
      enrollmentStatus: YunoStatus.succeded,
    );
    mockEnrollmentNotifier.simulateStateChange(newEnrollmentState);

    await tester.pump();
    expect(capturedEnrollmentState, equals(newEnrollmentState));
    expect(capturedEnrollmentContext, isNotNull);
  });

  testWidgets('YunoMultiListener notifies when payment state changes',
      (WidgetTester tester) async {
    YunoPaymentState? capturedPaymentState;
    BuildContext? capturedPaymentContext;

    await tester.pumpWidget(
      MaterialApp(
        home: YunoMultiListener(
          enrollmentListener: (_, __) {},
          paymentListener: (context, state) {
            capturedPaymentState = state;
            capturedPaymentContext = context;
          },
          child: const SizedBox(),
        ),
      ),
    );
    const newPaymentState = YunoPaymentState(
      token: 'test-token-123',
      paymentStatus: YunoStatus.succeded,
    );
    mockPaymentNotifier.simulateStateChange(newPaymentState);
    await tester.pump();
    expect(capturedPaymentState, equals(newPaymentState));
    expect(capturedPaymentContext, isNotNull);
  });

  testWidgets('YunoMultiListener renders child correctly',
      (WidgetTester tester) async {
    const key = Key('test-child');
    const child = SizedBox(key: key);

    await tester.pumpWidget(
      MaterialApp(
        home: YunoMultiListener(
          enrollmentListener: (_, __) {},
          paymentListener: (_, __) {},
          child: child,
        ),
      ),
    );

    expect(find.byKey(key), findsOneWidget);
  });

  testWidgets('YunoMultiListener handles multiple state changes',
      (WidgetTester tester) async {
    final enrollmentStates = <YunoEnrollmentState>[];
    final paymentStates = <YunoPaymentState>[];

    await tester.pumpWidget(
      MaterialApp(
        home: YunoMultiListener(
          enrollmentListener: (_, state) {
            enrollmentStates.add(state);
          },
          paymentListener: (_, state) {
            paymentStates.add(state);
          },
          child: const SizedBox(),
        ),
      ),
    );
    const enrollmentStateChanges = [
      YunoEnrollmentState(enrollmentStatus: YunoStatus.processing),
      YunoEnrollmentState(enrollmentStatus: YunoStatus.succeded),
      YunoEnrollmentState(enrollmentStatus: YunoStatus.fail),
    ];

    const paymentStateChanges = [
      YunoPaymentState(
        token: 'token-1',
        paymentStatus: YunoStatus.processing,
      ),
      YunoPaymentState(
        token: 'token-2',
        paymentStatus: YunoStatus.succeded,
      ),
      YunoPaymentState(
        token: 'token-3',
        paymentStatus: YunoStatus.fail,
      ),
    ];
    for (final state in enrollmentStateChanges) {
      mockEnrollmentNotifier.simulateStateChange(state);
      await tester.pump();
    }

    for (final state in paymentStateChanges) {
      mockPaymentNotifier.simulateStateChange(state);
      await tester.pump();
    }

    expect(enrollmentStates, equals(enrollmentStateChanges));
    expect(
      enrollmentStates.map((s) => s.enrollmentStatus).toList(),
      equals(
        [YunoStatus.processing, YunoStatus.succeded, YunoStatus.fail],
      ),
    );

    expect(paymentStates, equals(paymentStateChanges));
    expect(paymentStates.map((s) => s.token).toList(),
        equals(['token-1', 'token-2', 'token-3']));
    expect(
      paymentStates.map((s) => s.paymentStatus).toList(),
      equals(
        [YunoStatus.processing, YunoStatus.succeded, YunoStatus.fail],
      ),
    );
  });

  testWidgets('YunoMultiListener handles error and cancel states',
      (WidgetTester tester) async {
    YunoEnrollmentState? capturedEnrollmentState;
    YunoPaymentState? capturedPaymentState;

    await tester.pumpWidget(
      MaterialApp(
        home: YunoMultiListener(
          enrollmentListener: (_, state) {
            capturedEnrollmentState = state;
          },
          paymentListener: (_, state) {
            capturedPaymentState = state;
          },
          child: const SizedBox(),
        ),
      ),
    );
    const errorEnrollmentState = YunoEnrollmentState(
      enrollmentStatus: YunoStatus.internalError,
    );
    const cancelPaymentState = YunoPaymentState(
      token: 'cancel-token',
      paymentStatus: YunoStatus.cancelByUser,
    );

    mockEnrollmentNotifier.simulateStateChange(errorEnrollmentState);
    await tester.pump();
    mockPaymentNotifier.simulateStateChange(cancelPaymentState);
    await tester.pump();

    expect(capturedEnrollmentState?.enrollmentStatus,
        equals(YunoStatus.internalError));
    expect(
        capturedPaymentState?.paymentStatus, equals(YunoStatus.cancelByUser));
    expect(capturedPaymentState?.token, equals('cancel-token'));
  });
}
